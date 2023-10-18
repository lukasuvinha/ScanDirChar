# SCRIPT CODADO POR LUKAS UVINHA & CHAT GPT
<#

Este script em powershell tem o proposito de scanear e trazer para o usuario quais diretórios tem arquivos
que excedem a quantidade de 255 caracteres.

No primeiro bloco a baixo deste comentario, voce deve indicar qual diretório quer que o script faça o scan
na linha do $rootFolder. 
Voce tambem pode indicar ".\" caso queira que ele faça o scan no local que o arquivo de script se localiza.

Para um funcionamento correto, voce deve abrir o powershell no local que se encontra o arquivo 
e executar com " .\ScanDirChar3.ps1 | Out-File -FilePath .\resultado-ScanDirChar3.txt ".
desta forma, ao finalizar a execução do script, ele ira salvar a saida no arquivo indicado.

#>

# Defina a pasta raiz que você deseja escanear
$rootFolder = "E:\"

# Função para listar diretórios com mais de 255 caracteres
function Get-LongPaths {
    param (
        [string]$root
    )
    Get-ChildItem $root -Recurse -File | ForEach-Object {
        $path = $_.FullName
        if ($path.Length -gt 255) {
            $excessCharacters = $path.Length - 255
            [PSCustomObject]@{
                FilePath = $path
                ExcessCharacters = $excessCharacters
            }
        }
    }
}

# Função para formatar o caminho completo linearmente
function Format-LinearPath {
    param (
        [string]$path
    )
    $formattedPath = $path.Replace([System.IO.Path]::DirectorySeparatorChar, "/")
    return $formattedPath
}

# Chame a função e liste os arquivos
$longPaths = Get-LongPaths -root $rootFolder

if ($longPaths.Count -eq 0) {
    Write-Host "Nenhum arquivo com caminho superior a 255 caracteres encontrado."
} else {
    Write-Host "Arquivos com caminho superior a 255 caracteres:"
    $longPaths | ForEach-Object { Format-LinearPath $_.FilePath } | Format-Table -AutoSize
}