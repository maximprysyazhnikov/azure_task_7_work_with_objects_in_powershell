# task.ps1
# Script to find regions where VM size Standard_B2pts_v2 is available

# 1. Який саме VM size шукаємо
$targetSize = 'Standard_B2pts_v2'

# 2. Тека з JSON-файлами (data/)
$dataFolder = Join-Path $PSScriptRoot 'data'

# 3. Порожній список для результатів
$resultRegions = @()

# 4. Проходимо по всіх .json файлах у data/
Get-ChildItem -Path $dataFolder -Filter '*.json' | ForEach-Object {
    $file = $_

    # Отримуємо назву регіону з імені файлу (без .json)
    $regionName = [System.IO.Path]::GetFileNameWithoutExtension($file.Name)

    # Читаємо файл, конвертуємо JSON в об’єкти
    $vmSizes = Get-Content -Path $file.FullName -Raw | ConvertFrom-Json

    # Шукаємо, чи є серед об’єктів такий, у якого Name == Standard_B2pts_v2
    $match = $vmSizes | Where-Object { $_.Name -eq $targetSize }

    if ($match) {
        # Якщо знайдено — додаємо регіон у результат
        $resultRegions += $regionName
    }
}

# 5. Конвертуємо список регіонів у JSON і зберігаємо в result.json у корені репо
$resultPath = Join-Path $PSScriptRoot 'result.json'
$resultRegions | ConvertTo-Json | Set-Content -Path $resultPath -Encoding utf8
