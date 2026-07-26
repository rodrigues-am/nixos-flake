{ pkgs, ... }:

let
  pdf2txt = pkgs.writeShellScriptBin "pdf2txt" ''

    # Diretório com os PDFs
    PDF_DIR="./"
    # Diretório de saída para textos
    TXT_DIR="./textos"
    # Arquivo final concatenado
    OUTPUT_FILE="documento_completo.txt"

    # Criar diretório de textos se não existir
    mkdir -p "$TXT_DIR"

    # Converter todos os PDFs para texto
    for pdf in "$PDF_DIR"/*.pdf; do
        if [ -f "$pdf" ]; then
            nome_base=$(basename "$pdf" .pdf)
            echo "Convertendo: $pdf"
            pdftotext "$pdf" "$TXT_DIR/$nome_base.txt"
        fi
    done

    # Concatenar todos os arquivos de texto
    echo "Concatenando arquivos..."
    cat "$TXT_DIR"/*.txt > "$OUTPUT_FILE"

    echo "Processo concluído! Arquivo final: $OUTPUT_FILE"  '';
in { home.packages = [ pdf2txt ]; }
