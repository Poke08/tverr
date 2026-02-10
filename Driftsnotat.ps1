# Laster inn .NET-biblioteket som gjør det mulig å lage grafiske vinduer (GUI)
# Uten denne linjen finnes ikke Form, TextBox, Button osv.
Add-Type -AssemblyName System.Windows.Forms


#Henter dato, brukernavn, pcnavn og windows versjon
$timestamp = Get-Date -Format "yyyy-MM-dd HH:mm"
$username = $env:USERNAME
$pcname = $env:COMPUTERNAME
$winVersion = (Get-CimInstance Win32_OperatingSystem).Caption


# Oppretter et nytt vindu (Form = hovedvindu i programmet)
$form = New-Object System.Windows.Forms.Form

# Teksten som vises øverst i vinduet (tittellinjen)
$form.Text = "Driftslogg - Lokal PC"

# Størrelsen på vinduet (bredde, høyde i piksler)
$form.Size = "400,500"

# Sørger for at vinduet åpnes midt på skjermen
$form.StartPosition = "CenterScreen"


# Oppretter et tekstfelt hvor brukeren kan skrive
$previewBox = New-Object System.Windows.Forms.TextBox

# Multiline = true gjør at tekstfeltet kan inneholde flere linjer
$previewBox.Multiline = $true

# Størrelsen på tekstfeltet
$previewBox.Size = "360,120"

# Plassering i vinduet (X, Y fra øvre venstre hjørne)
$previewBox.Location = "10,10"


# Oppretter et tekstfelt hvor brukeren kan skrive
$textBox = New-Object System.Windows.Forms.TextBox

# Multiline = true gjør at tekstfeltet kan inneholde flere linjer
$textBox.Multiline = $true

# Størrelsen på tekstfeltet
$textBox.Size = "360,120"

# Plassering i vinduet (X, Y fra øvre venstre hjørne)
$textBox.Location = "10,150"


# Oppretter en knapp
$button = New-Object System.Windows.Forms.Button

# Teksten som vises på knappen
$button.Text = "Lagre"

# Hvor knappen skal ligge i vinduet
$button.Location = "10,280"

$comboBox = New Object System.Windows.Forms.ComboBox
$comboBox.Location = "10,135"
$comboBox.Width = "200"

$comboBox.Items.Add("Brukerstøtte")
$comboBox.Items.Add("Feilsøking")
$comboBox.Items.Add("Programinstallasjon")
$comboBox.Items.Add("Nettverksproblem")
$comboBox.Items.Add("Annet")

$previewBox.Text = "Dato: $timestamp
Bruker: $username
PC-navn: $pcname
Windows versjon: $winVersion
--------------------
Sakstype: $saksType"


# Definerer hva som skal skje når brukeren klikker på knappen
$button.Add_Click({
    # Finner banen til brukerens Documents-mappe
    # Dette fungerer uansett brukernavn og PC
    $docPath = [Environment]::GetFolderPath("MyDocuments")

    # Setter sammen full filsti:
    # Documents + filnavn = f.eks. C:\Users\Ola\Documents\notat.txt
    $file = Join-Path $docPath "Drifstlogg.txt"

    #Legger alt som skal med i fila inn i en variabel ($content)
    $content = "Dato: $timestamp`r`nBruker: $username`r`nPC-navn: $pcname`r`nWindows versjon: $winVersion`r`n--------------------`r`n$($textBox.Text)`r`n`r`n"

    # Innholdet i tekstfeltet skrives til fil
    # UTF8 sikrer at æ, ø og å lagres riktig
    $content | Out-File $file -Encoding UTF8 -Append

    # Viser en meldingsboks når lagringen er ferdig
    [System.Windows.Forms.MessageBox]::Show("Notatet er lagret i Dokumenter")
})


# Legger tekstfeltet inn i vinduet
$form.Controls.Add($textBox)

$form.Controls.Add($previewBox)

# Legger knappen inn i vinduet
$form.Controls.Add($button)

$form.Controls.Add($comboBox)


# Viser vinduet og stopper skriptet helt til brukeren lukker det
[void]$form.ShowDialog()
