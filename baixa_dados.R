



a <- 1+1

a * 3


tjsp::baixar_cjsg(
  "covid", 
  diretorio = "cjsg", 
  n = 10
)

dados <- fs::dir_ls("cjsg") |> 
  tjsp::ler_cjsg()


tjsp::autenticar(
  Sys.getenv("ESAJ_LOGIN"),
  Sys.getenv("ESAJ_SENHA")
)

processos <- head(dados$processo, 50)

# abjutils::build_id(processos)

tjsp::baixar_cposg(processos, "cposg")

dados_cposg <- fs::dir_ls("cposg") |> 
  purrr::map_dfr(tjsp::ler_decisoes_cposg, .id = "file")

rx_unanimidade <- stringr::regex(
  "V\\. ?U\\.|un[aâ]n", 
  ignore_case = TRUE
)

dados_cposg_classificado <- dados_cposg |> 
  dplyr::mutate(
    unanime = stringr::str_detect(
      dispositivo, 
      rx_unanimidade
    )
  )

dados_cposg_classificado |> 
  dplyr::count(unanime) |> 
  dplyr::mutate(prop = n/sum(n))
