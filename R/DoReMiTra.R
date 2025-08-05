
# apply VST if RNA-seq data is detected
get_expr_matrix <- function(se) {
  if (inherits(se, "DESeqDataSet")) {
    assay(vst(se, blind = TRUE))
  } else {
    exprs_raw <- if ("exprs" %in% names(assays(se))) {
      assays(se)$exprs
    } else {
      assay(se)
    }

    is_count_data <- all(exprs_raw == floor(exprs_raw)) && min(exprs_raw) >= 0

    if (!is.null(metadata(se)$Platform) && metadata(se)$Platform == "RNAseq") {
      dds <- suppressMessages(DESeqDataSetFromMatrix(countData = exprs_raw, colData = colData(se), design = ~1))
      assay(vst(dds, blind = TRUE))
    } else {
      exprs_raw
    }
  }
}

#' Launch DoReMiTra Shiny App
#'
#' @param se A SummarizedExperiment object
#'
#' @export
#'
#' @importFrom shiny
#'
#'
DoReMiTra <- function(se) {
  se_name <- deparse(substitute(se))
  ui <- dashboardPage(
    header = dashboardHeader(title = "DoReMiTra Explorer"),
    sidebar = dashboardSidebar(
      collapsed = FALSE,
      minified = FALSE,
      fixed = TRUE,
      sidebarMenu(
        id = "tabs",
        menuItem("Summary", tabName = "summary", icon = icon("eye")),
        menuItem("PCA", tabName = "pca", icon = icon("chart-line")),
        menuItem("Heatmap", tabName = "heatmap", icon = icon("th")),
        menuItem("Boxplot", tabName = "boxplot", icon = icon("box-open")),
        menuItem("Gene Plot", tabName = "geneplot", icon = icon("dna"))
      ),
      conditionalPanel(
        condition = "input.tabs == 'heatmap'",
        hr(),
        h4("Heatmap Controls"),
        numericInput("topn", "Top variable genes:", value = 50, min = 5),
        numericInput("clusters", "Number of clusters:", value = 2, min = 1),
        checkboxInput("cluster_rows", "Cluster rows", value = TRUE),
        checkboxInput("cluster_cols", "Cluster columns", value = TRUE)
      ),
      conditionalPanel(
        condition = "input.tabs == 'pca'",
        hr(),
        pickerInput("pca_group_var", "Group by:",
                    choices = colnames(colData(se)),
                    selected = colnames(colData(se))[1]),
        numericInput("pca_topn", "Number of top variable genes:",
                    value = 500,
                    min = 100)
      ),
      conditionalPanel(
        condition = "input.tabs == 'boxplot'",
        hr(),
        pickerInput("box_group_var", "Group by:",
                    choices = colnames(colData(se)),
                    selected = colnames(colData(se))[1])
      ),
      conditionalPanel(
        condition = "input.tabs == 'geneplot'",
        hr(),
        pickerInput("gene", "Select gene to plot:",
                    choices = rownames(get_expr_matrix(se)),
                    selected = rownames(get_expr_matrix(se))[1]),
        pickerInput("geneplot_group", "Group by:",
                    choices = if("Dose" %in% colnames(colData(se))) "Dose" else colnames(colData(se)),
                    selected = if("Dose" %in% colnames(colData(se))) "Dose" else colnames(colData(se))[1]),
        checkboxInput("geneplot_labels", "Show sample labels", value = FALSE)
      )
    ),
    body = dashboardBody(
      tags$head(
        tags$style(HTML(".main-header .sidebar-toggle, .main-header .controlbar-toggle { display: none !important; } .skin-dark, .dark-mode { background-color: #fff !important; }"))
      ),
      tabItems(
        tabItem(tabName = "summary", uiOutput("summary_ui")),
        tabItem(tabName = "pca", plotOutput("pca_plot")),
        tabItem(tabName = "heatmap", plotOutput("heatmap", height = "700px")),
        tabItem(tabName = "boxplot", plotOutput("boxplot")),
        tabItem(tabName = "geneplot", plotOutput("gene_plot"))
      )
    ),
    controlbar = NULL,
    dark = FALSE,
    skin = "light",
    title = "DoReMiTra",

  footer = dashboardFooter(left = "© 2025 DoReMiTra", right = NULL))

  server <- function(input, output, session) {
    mat <- get_expr_matrix(se)

    output$summary_ui <- renderUI({
      n_samples <- ncol(se)
      n_genes <- nrow(se)
      meta_cols <- paste(colnames(colData(se)), collapse = ", ")
      organism <- if ("Organism" %in% colnames(colData(se))) unique(as.character(colData(se)$Organism)) else "NA"
      radiation_type <- if ("Radiation_type" %in% colnames(colData(se))) unique(as.character(colData(se)$Radiation_type)) else "NA"
      exp_setting <- if ("Exp_setting" %in% colnames(colData(se))) unique(as.character(colData(se)$Exp_setting)) else "NA"
      data_type <- if (!is.null(metadata(se)$type)) metadata(se)$type else "Microarray"
      organism <- paste(organism, collapse = ", ")
      radiation_type <- paste(radiation_type, collapse = ", ")
      exp_setting <- paste(exp_setting, collapse = ", ")
      tagList(
        tags$b("Dataset: "), se_name, tags$br(),
        tags$b("Data Type: "), data_type, tags$br(),
        tags$b("Organism(s): "), organism, tags$br(),
        tags$b("Radiation Type: "), radiation_type, tags$br(),
        tags$b("Experiment Setting: "), exp_setting, tags$br(),
        tags$b("Number of Genes: "), n_genes, tags$br(),
        tags$b("Number of Samples: "), n_samples, tags$br()
      )
    })

    output$pca_plot <- renderPlot({

      topn <- as.numeric(input$pca_topn)

      # Calculate variances for all genes
      gene_vars <- matrixStats::rowVars(mat)

      # Ensure topn does not exceed number of genes
      topn <- min(topn, length(gene_vars))

      # Select top variable genes
      top_genes <- order(gene_vars, decreasing = TRUE)[1:topn]

      mat_top <- mat[top_genes, , drop = FALSE]

      # Filter rows with finite values only
      row_ok <- apply(mat_top, 1, function(x) all(is.finite(x) & !is.na(x)))
      mat_clean <- mat_top[row_ok, , drop = FALSE]

      pca_res <- prcomp(t(mat_clean), scale. = TRUE)

      percentVar <- round(100 * (pca_res$sdev^2 / sum(pca_res$sdev^2)), 1)

      df <- data.frame(pca_res$x[, 1:2], colData(se))

      ggplot(df, aes_string(x = "PC1", y = "PC2", color = input$pca_group_var)) +
        geom_point(size = 3) +
        xlab(paste0("PC1: ", percentVar[1], "% variance")) +
        ylab(paste0("PC2: ", percentVar[2], "% variance")) +
        theme_minimal()
    })


    output$heatmap <- renderPlot({
      var_genes <- head(order(matrixStats::rowVars(mat), decreasing = TRUE), input$topn)
      dose <- if ("Dose" %in% colnames(colData(se))) factor(colData(se)$Dose) else factor(rep(NA, ncol(mat)))
      dose_levels <- levels(dose)
      dose_colors <- RColorBrewer::brewer.pal(max(3, length(dose_levels)), "Set1")[1:length(dose_levels)]
      names(dose_colors) <- dose_levels
      ha <- ComplexHeatmap::HeatmapAnnotation(Dose = dose, col = list(Dose = dose_colors))
      ht <- ComplexHeatmap::Heatmap(
        mat[var_genes, ] - rowMeans(mat[var_genes, ]),
        name = "Scaled Expression",
        cluster_rows = input$cluster_rows,
        cluster_columns = input$cluster_cols,
        row_km = input$clusters,
        show_row_names = TRUE,
        show_column_names = TRUE,
        top_annotation = ha
      )
      ComplexHeatmap::draw(ht)
    })

    output$boxplot <- renderPlot({
      df <- data.frame(
        Expression = as.vector(mat),
        Sample = rep(colnames(mat), each = nrow(mat)),
        Group = rep(colData(se)[[input$box_group_var]], each = nrow(mat))
      )
      ggplot(df, aes(x = Group, y = Expression)) +
        geom_boxplot(fill = "lightblue") +
        theme_minimal() +
        labs(title = "Overall Gene Expression", x = input$box_group_var, y = "Expression")
    })

    output$gene_plot <- renderPlot({
      req(input$gene)
      gene <- input$gene
      group_var <- input$geneplot_group
      show_labels <- input$geneplot_labels

      if (!(gene %in% rownames(mat))) {
        plot.new(); text(0.5, 0.5, "Selected gene not found in dataset.", cex = 1.5); return()
      }
      if (!(group_var %in% colnames(colData(se)))) {
        plot.new(); text(0.5, 0.5, "Selected group not found in metadata.", cex = 1.5); return()
      }

      df <- data.frame(
        exp_value = as.numeric(mat[gene, ]),
        sample_id = colnames(mat),
        Group = colData(se)[[group_var]]
      )

      p <- ggplot(df, aes(x = factor(Group), y = exp_value, color = factor(Group))) +
        geom_jitter(position = position_jitter(width = 0.2, height = 0, seed = 42), size = 3) +
        theme_bw() +
        xlab(group_var) +
        ylab("Normalized Expression") +
        labs(title = paste0(gene, " expression by ", group_var))

      if (show_labels) {
        p <- p + ggrepel::geom_text_repel(aes(label = sample_id), min.segment.length = 0)
      }
      p + stat_summary(fun = mean, geom = "line", aes(group = 1), color = "grey80", linewidth = 0.8)
    })
  }

  shinyApp(ui, server)
}
