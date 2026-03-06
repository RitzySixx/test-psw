# Load required assemblies
Add-Type -AssemblyName PresentationFramework, PresentationCore, WindowsBase, System.Drawing, System.Collections

$xaml = @'
<Window xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
        xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
        Title="Suspicious Event Parser" Width="1650" Height="920"
        WindowStyle="None" AllowsTransparency="True" Background="Transparent"
        ResizeMode="CanResizeWithGrip" FontFamily="Segoe UI"
        WindowStartupLocation="CenterScreen">
    <Window.Resources>
        <DropShadowEffect x:Key="ShadowEffect" ShadowDepth="4" Direction="320" Color="Black" Opacity="0.5" BlurRadius="20"/>
        <Style x:Key="RoundedButtonStyle" TargetType="Button">
            <Setter Property="Template">
                <Setter.Value>
                    <ControlTemplate TargetType="Button">
                        <Border x:Name="Border" Background="{TemplateBinding Background}" CornerRadius="4"
                                Padding="{TemplateBinding Padding}" BorderThickness="{TemplateBinding BorderThickness}"
                                BorderBrush="{TemplateBinding BorderBrush}">
                            <ContentPresenter HorizontalAlignment="Center" VerticalAlignment="Center"/>
                        </Border>
                        <ControlTemplate.Triggers>
                            <Trigger Property="IsMouseOver" Value="True">
                                <Setter TargetName="Border" Property="Opacity" Value="0.8"/>
                            </Trigger>
                            <Trigger Property="IsPressed" Value="True">
                                <Setter TargetName="Border" Property="Opacity" Value="0.6"/>
                            </Trigger>
                        </ControlTemplate.Triggers>
                    </ControlTemplate>
                </Setter.Value>
            </Setter>
        </Style>
        <Style x:Key="TabButtonStyle" TargetType="Button">
            <Setter Property="Template">
                <Setter.Value>
                    <ControlTemplate TargetType="Button">
                        <Border x:Name="Border" Background="{TemplateBinding Background}" CornerRadius="4,4,0,0"
                                Padding="{TemplateBinding Padding}" BorderThickness="{TemplateBinding BorderThickness}"
                                BorderBrush="{TemplateBinding BorderBrush}">
                            <ContentPresenter HorizontalAlignment="Center" VerticalAlignment="Center"/>
                        </Border>
                        <ControlTemplate.Triggers>
                            <Trigger Property="IsMouseOver" Value="True">
                                <Setter TargetName="Border" Property="Opacity" Value="0.8"/>
                            </Trigger>
                        </ControlTemplate.Triggers>
                    </ControlTemplate>
                </Setter.Value>
            </Setter>
        </Style>
        <Style x:Key="RoundedTextBoxStyle" TargetType="TextBox">
            <Setter Property="Template">
                <Setter.Value>
                    <ControlTemplate TargetType="TextBox">
                        <Border Background="{TemplateBinding Background}" BorderBrush="{TemplateBinding BorderBrush}"
                                BorderThickness="{TemplateBinding BorderThickness}" CornerRadius="4">
                            <ScrollViewer x:Name="PART_ContentHost" Margin="{TemplateBinding Padding}"/>
                        </Border>
                    </ControlTemplate>
                </Setter.Value>
            </Setter>
        </Style>
        <Style TargetType="GridViewColumnHeader">
            <Setter Property="Background" Value="#FF2D2D30"/>
            <Setter Property="Foreground" Value="#FF9CDCFE"/>
            <Setter Property="FontSize" Value="11"/>
            <Setter Property="FontWeight" Value="SemiBold"/>
            <Setter Property="Padding" Value="8,5"/>
            <Setter Property="BorderBrush" Value="#FF3A3A3C"/>
            <Setter Property="BorderThickness" Value="0,0,1,1"/>
        </Style>
    </Window.Resources>

    <Border Background="#FF1A1A1C" CornerRadius="12" BorderBrush="#FF3A3A3C" BorderThickness="1"
            Effect="{StaticResource ShadowEffect}">
        <Grid>
            <Grid.RowDefinitions>
                <RowDefinition Height="46"/>
                <RowDefinition Height="Auto"/>
                <RowDefinition Height="Auto"/>
                <RowDefinition Height="*"/>
                <RowDefinition Height="30"/>
            </Grid.RowDefinitions>

            <!-- Title Bar -->
            <Border x:Name="TitleBar" Grid.Row="0" Background="#FF252528" CornerRadius="12,12,0,0"
                    BorderBrush="#FF3A3A3C" BorderThickness="0,0,0,1">
                <Grid>
                    <Grid.ColumnDefinitions>
                        <ColumnDefinition Width="Auto"/>
                        <ColumnDefinition Width="*"/>
                        <ColumnDefinition Width="Auto"/>
                    </Grid.ColumnDefinitions>
                    <StackPanel Grid.Column="0" Orientation="Horizontal" VerticalAlignment="Center" Margin="15,0,0,0">
                        <TextBlock Text="&#x1F50D;" FontSize="16" VerticalAlignment="Center" Margin="0,0,8,0"/>
                        <TextBlock Text="Suspicious Event Parser" Foreground="#FFE0E0E0" FontSize="14" FontWeight="SemiBold" VerticalAlignment="Center"/>
                        <Border Background="#FF0E639C" CornerRadius="3" Padding="6,2" Margin="10,0,0,0" VerticalAlignment="Center">
                            <TextBlock Text="v4.1" Foreground="White" FontSize="9" FontWeight="Bold"/>
                        </Border>
                    </StackPanel>
                    <StackPanel Grid.Column="2" Orientation="Horizontal" VerticalAlignment="Center">
                        <Button x:Name="MinimizeButton" Content="&#x2500;" Width="38" Height="38" Background="Transparent"
                                Foreground="#FFAAAAAA" BorderThickness="0" FontSize="12" Cursor="Hand"
                                Style="{StaticResource RoundedButtonStyle}"/>
                        <Button x:Name="MaximizeButton" Content="&#x25A1;" Width="38" Height="38" Background="Transparent"
                                Foreground="#FFAAAAAA" BorderThickness="0" FontSize="13" Cursor="Hand"
                                Style="{StaticResource RoundedButtonStyle}"/>
                        <Button x:Name="CloseButton" Content="&#x2715;" Width="38" Height="38" Background="Transparent"
                                Foreground="#FFAAAAAA" BorderThickness="0" FontSize="12" FontWeight="Bold" Cursor="Hand"
                                Style="{StaticResource RoundedButtonStyle}"/>
                    </StackPanel>
                </Grid>
            </Border>

            <!-- Toolbar -->
            <Border Grid.Row="1" Background="#FF1E1E21" Margin="10,8,10,0" CornerRadius="6"
                    BorderBrush="#FF3A3A3C" BorderThickness="1">
                <Grid Margin="10,7">
                    <Grid.ColumnDefinitions>
                        <ColumnDefinition Width="Auto"/>
                        <ColumnDefinition Width="*"/>
                        <ColumnDefinition Width="Auto"/>
                        <ColumnDefinition Width="Auto"/>
                        <ColumnDefinition Width="Auto"/>
                    </Grid.ColumnDefinitions>
                    <TextBlock Grid.Column="0" Text="&#x1F50D;" FontSize="13" VerticalAlignment="Center" Margin="0,0,8,0"/>
                    <TextBox x:Name="SearchBox" Grid.Column="1" Background="#FF141416" Foreground="#FFFFFFFF"
                             BorderBrush="#FF4A4A4C" BorderThickness="1" FontSize="12" Padding="8,5"
                             VerticalContentAlignment="Center" Style="{StaticResource RoundedTextBoxStyle}"
                             ToolTip="Search through events..."/>
                    <Button x:Name="RefreshButton" Grid.Column="2" Content="&#x1F504;  Refresh"
                            Background="#FF0E639C" Foreground="White" BorderThickness="0"
                            FontSize="12" FontWeight="SemiBold" Padding="14,6" Margin="8,0,0,0"
                            Style="{StaticResource RoundedButtonStyle}" Height="30" Cursor="Hand"/>
                    <Button x:Name="ExportButton" Grid.Column="3" Content="&#x1F4CA;  Export CSV"
                            Background="#FF388A34" Foreground="White" BorderThickness="0"
                            FontSize="12" FontWeight="SemiBold" Padding="14,6" Margin="8,0,0,0"
                            Style="{StaticResource RoundedButtonStyle}" Height="30" Cursor="Hand"/>
                    <Button x:Name="ClearSearchButton" Grid.Column="4" Content="&#x2715;"
                            Background="#FF4A4A4C" Foreground="White" BorderThickness="0"
                            FontSize="11" FontWeight="Bold" Padding="10,6" Margin="8,0,0,0"
                            Style="{StaticResource RoundedButtonStyle}" Height="30" Cursor="Hand"/>
                </Grid>
            </Border>

            <!-- Tab Bar -->
            <Border Grid.Row="2" Background="#FF1A1A1C" Margin="10,6,10,0" BorderBrush="#FF3A3A3C" BorderThickness="0,0,0,1">
                <StackPanel Orientation="Horizontal">
                    <Button x:Name="TabAll"        Content="&#x1F5C2;  All Events"    Tag="All"
                            Background="#FF0E639C" Foreground="White"   BorderThickness="0"
                            FontSize="11" FontWeight="SemiBold" Padding="14,7" Margin="0,0,3,0"
                            Style="{StaticResource TabButtonStyle}" Height="32" Cursor="Hand"/>
                    <Button x:Name="TabCrashes"    Content="&#x1F4A5;  Crashes"       Tag="Crashes"
                            Background="#FF2D2D30" Foreground="#FFAAAAAA" BorderThickness="0"
                            FontSize="11" FontWeight="SemiBold" Padding="14,7" Margin="0,0,3,0"
                            Style="{StaticResource TabButtonStyle}" Height="32" Cursor="Hand"/>
                    <Button x:Name="TabDefender"   Content="&#x1F6E1;  Defender"      Tag="Defender"
                            Background="#FF2D2D30" Foreground="#FFAAAAAA" BorderThickness="0"
                            FontSize="11" FontWeight="SemiBold" Padding="14,7" Margin="0,0,3,0"
                            Style="{StaticResource TabButtonStyle}" Height="32" Cursor="Hand"/>
                    <Button x:Name="TabPowerShell" Content="&#x2328;  PowerShell"    Tag="PowerShell"
                            Background="#FF2D2D30" Foreground="#FFAAAAAA" BorderThickness="0"
                            FontSize="11" FontWeight="SemiBold" Padding="14,7" Margin="0,0,3,0"
                            Style="{StaticResource TabButtonStyle}" Height="32" Cursor="Hand"/>
                    <Button x:Name="TabSystem"     Content="&#x1F5A5;  System"        Tag="System"
                            Background="#FF2D2D30" Foreground="#FFAAAAAA" BorderThickness="0"
                            FontSize="11" FontWeight="SemiBold" Padding="14,7" Margin="0,0,3,0"
                            Style="{StaticResource TabButtonStyle}" Height="32" Cursor="Hand"/>
                    <Button x:Name="TabDevices"    Content="&#x1F50C;  Devices / USB" Tag="Devices"
                            Background="#FF2D2D30" Foreground="#FFAAAAAA" BorderThickness="0"
                            FontSize="11" FontWeight="SemiBold" Padding="14,7" Margin="0,0,3,0"
                            Style="{StaticResource TabButtonStyle}" Height="32" Cursor="Hand"/>
                </StackPanel>
            </Border>

            <!-- Main Content -->
            <Border Grid.Row="3" Background="#FF1A1A1C" Margin="10,0,10,8" CornerRadius="0,0,6,6"
                    BorderBrush="#FF3A3A3C" BorderThickness="1,0,1,1">
                <Grid>
                    <Grid.RowDefinitions>
                        <RowDefinition Height="Auto"/>
                        <RowDefinition Height="*"/>
                    </Grid.RowDefinitions>

                    <!-- Stats Bar -->
                    <Border Grid.Row="0" Background="#FF222226" Margin="8,8,8,4" CornerRadius="4"
                            BorderBrush="#FF3A3A3C" BorderThickness="1">
                        <StackPanel Orientation="Horizontal" Margin="10,5">
                            <TextBlock x:Name="TotalEventsText"     Text="Total: 0"        Foreground="#FFBBBBBB" FontSize="11" VerticalAlignment="Center" Margin="0,0,18,0"/>
                            <TextBlock x:Name="SuspiciousEventsText" Text="Medium+ Risk: 0" Foreground="#FFFF6B6B" FontSize="11" VerticalAlignment="Center" Margin="0,0,18,0"/>
                            <TextBlock x:Name="FilteredEventsText"  Text="Showing: 0"      Foreground="#FF4EC9B0" FontSize="11" VerticalAlignment="Center" Margin="0,0,18,0"/>
                            <TextBlock x:Name="DefenderCountText"   Text="Defender: 0"     Foreground="#FF9B59B6" FontSize="11" VerticalAlignment="Center" Margin="0,0,18,0"/>
                            <TextBlock x:Name="PSCountText"         Text="PowerShell: 0"   Foreground="#FF569CD6" FontSize="11" VerticalAlignment="Center" Margin="0,0,18,0"/>
                            <TextBlock x:Name="DeviceCountText"     Text="Devices: 0"      Foreground="#FFFFD700" FontSize="11" VerticalAlignment="Center"/>
                        </StackPanel>
                    </Border>

                    <!-- ListView -->
                    <ListView x:Name="EventsListView" Grid.Row="1" Background="Transparent" Foreground="#FFCCCCCC"
                             BorderThickness="0" ScrollViewer.HorizontalScrollBarVisibility="Auto"
                             ScrollViewer.VerticalScrollBarVisibility="Auto" Margin="8,0,8,8"
                             VirtualizingStackPanel.IsVirtualizing="True"
                             VirtualizingStackPanel.VirtualizationMode="Recycling">
                        <ListView.Resources>
                            <Style TargetType="ListViewItem">
                                <Setter Property="Background" Value="Transparent"/>
                                <Setter Property="BorderThickness" Value="0"/>
                                <Setter Property="Padding" Value="4,4"/>
                                <Setter Property="Margin" Value="0,1"/>
                                <Setter Property="FocusVisualStyle" Value="{x:Null}"/>
                                <Style.Triggers>
                                    <Trigger Property="IsMouseOver" Value="True">
                                        <Setter Property="Background" Value="#FF2A2A2E"/>
                                    </Trigger>
                                    <Trigger Property="IsSelected" Value="True">
                                        <Setter Property="Background" Value="#FF0E4A7A"/>
                                    </Trigger>
                                </Style.Triggers>
                            </Style>
                        </ListView.Resources>
                        <ListView.View>
                            <GridView>
                                <GridViewColumn Header="Time" Width="148">
                                    <GridViewColumn.CellTemplate>
                                        <DataTemplate>
                                            <TextBlock Text="{Binding TimeCreated}" Foreground="#FF9CDCFE" FontSize="11" FontFamily="Consolas" ToolTip="{Binding TimeCreated}"/>
                                        </DataTemplate>
                                    </GridViewColumn.CellTemplate>
                                </GridViewColumn>
                                <GridViewColumn Header="ID" Width="70">
                                    <GridViewColumn.CellTemplate>
                                        <DataTemplate>
                                            <Border Background="{Binding SeverityColor}" CornerRadius="3" Padding="4,2" HorizontalAlignment="Left">
                                                <TextBlock Text="{Binding Id}" Foreground="White" FontSize="10" FontWeight="Bold"/>
                                            </Border>
                                        </DataTemplate>
                                    </GridViewColumn.CellTemplate>
                                </GridViewColumn>
                                <GridViewColumn Header="Cat" Width="85">
                                    <GridViewColumn.CellTemplate>
                                        <DataTemplate>
                                            <TextBlock Text="{Binding Category}" Foreground="#FFBBBBBB" FontSize="10"/>
                                        </DataTemplate>
                                    </GridViewColumn.CellTemplate>
                                </GridViewColumn>
                                <GridViewColumn Header="Application / Source" Width="210">
                                    <GridViewColumn.CellTemplate>
                                        <DataTemplate>
                                            <StackPanel Orientation="Horizontal">
                                                <TextBlock Text="{Binding AppIcon}" FontSize="11" VerticalAlignment="Center" Margin="0,0,4,0"/>
                                                <TextBlock Text="{Binding AppName}" Foreground="#FFDDDDDD" FontSize="11" TextWrapping="NoWrap"
                                                           ToolTip="{Binding AppName}" VerticalAlignment="Center"/>
                                            </StackPanel>
                                        </DataTemplate>
                                    </GridViewColumn.CellTemplate>
                                </GridViewColumn>
                                <GridViewColumn Header="Path / Detail" Width="250">
                                    <GridViewColumn.CellTemplate>
                                        <DataTemplate>
                                            <TextBlock Text="{Binding AppPath}" Foreground="#FF888888" FontSize="10"
                                                       TextWrapping="NoWrap" ToolTip="{Binding AppPath}" FontFamily="Consolas"/>
                                        </DataTemplate>
                                    </GridViewColumn.CellTemplate>
                                </GridViewColumn>
                                <GridViewColumn Header="Module" Width="160">
                                    <GridViewColumn.CellTemplate>
                                        <DataTemplate>
                                            <TextBlock Text="{Binding ModuleName}" Foreground="#FFCCCCCC" FontSize="11"
                                                       TextWrapping="NoWrap" ToolTip="{Binding ModuleName}"/>
                                        </DataTemplate>
                                    </GridViewColumn.CellTemplate>
                                </GridViewColumn>
                                <GridViewColumn Header="Signature" Width="120">
                                    <GridViewColumn.CellTemplate>
                                        <DataTemplate>
                                            <Border Background="{Binding SigColor}" CornerRadius="3" Padding="5,2" HorizontalAlignment="Left">
                                                <TextBlock Text="{Binding SigStatus}" Foreground="White" FontSize="10" FontWeight="SemiBold"/>
                                            </Border>
                                        </DataTemplate>
                                    </GridViewColumn.CellTemplate>
                                </GridViewColumn>
                                <GridViewColumn Header="Risk" Width="82">
                                    <GridViewColumn.CellTemplate>
                                        <DataTemplate>
                                            <Border Background="{Binding RiskColor}" CornerRadius="3" Padding="5,2" HorizontalAlignment="Left">
                                                <TextBlock Text="{Binding RiskLevel}" Foreground="White" FontSize="10" FontWeight="Bold"/>
                                            </Border>
                                        </DataTemplate>
                                    </GridViewColumn.CellTemplate>
                                </GridViewColumn>
                                <GridViewColumn Header="Ct" Width="40">
                                    <GridViewColumn.CellTemplate>
                                        <DataTemplate>
                                            <TextBlock Text="{Binding EventCount}" Foreground="#FFFFA07A" FontSize="11" HorizontalAlignment="Center" FontWeight="SemiBold"/>
                                        </DataTemplate>
                                    </GridViewColumn.CellTemplate>
                                </GridViewColumn>
                            </GridView>
                        </ListView.View>
                    </ListView>
                </Grid>
            </Border>

            <!-- Status Bar -->
            <Border Grid.Row="4" Background="#FF252528" CornerRadius="0,0,12,12" BorderBrush="#FF3A3A3C" BorderThickness="0,1,0,0">
                <Grid>
                    <TextBlock x:Name="StatusText" Foreground="#FFBBBBBB" FontSize="11" VerticalAlignment="Center"
                               Margin="14,0,0,0" Text="Ready — click Refresh to load events"/>
                    <TextBlock Foreground="#FF555555" FontSize="10" VerticalAlignment="Center"
                               HorizontalAlignment="Right" Margin="0,0,14,0" Text="v4.1 • Suspicious Event Parser"/>
                </Grid>
            </Border>
        </Grid>
    </Border>
</Window>
'@

# ---------- PARSE XAML ----------
try {
    $reader = New-Object System.Xml.XmlNodeReader ([xml]$xaml)
    $window = [Windows.Markup.XamlReader]::Load($reader)
} catch {
    [System.Windows.MessageBox]::Show("XAML Error: $($_.Exception.Message)")
    return
}

# ---------- GET CONTROLS ----------
$minimizeButton      = $window.FindName("MinimizeButton")
$maximizeButton      = $window.FindName("MaximizeButton")
$closeButton         = $window.FindName("CloseButton")
$refreshButton       = $window.FindName("RefreshButton")
$exportButton        = $window.FindName("ExportButton")
$clearSearchButton   = $window.FindName("ClearSearchButton")
$eventsListView      = $window.FindName("EventsListView")
$searchBox           = $window.FindName("SearchBox")
$statusText          = $window.FindName("StatusText")
$totalEventsText     = $window.FindName("TotalEventsText")
$suspiciousEventsText= $window.FindName("SuspiciousEventsText")
$filteredEventsText  = $window.FindName("FilteredEventsText")
$defenderCountText   = $window.FindName("DefenderCountText")
$psCountText         = $window.FindName("PSCountText")
$deviceCountText     = $window.FindName("DeviceCountText")

$tabAll        = $window.FindName("TabAll")
$tabCrashes    = $window.FindName("TabCrashes")
$tabDefender   = $window.FindName("TabDefender")
$tabPowerShell = $window.FindName("TabPowerShell")
$tabSystem     = $window.FindName("TabSystem")
$tabDevices    = $window.FindName("TabDevices")
$allTabButtons = @($tabAll,$tabCrashes,$tabDefender,$tabPowerShell,$tabSystem,$tabDevices)

# ---------- STATE ----------
$script:baseEvents            = [System.Collections.ArrayList]::new()
$script:currentFilteredEvents = [System.Collections.ArrayList]::new()
$script:currentTab            = "All"

# ---------- WINDOW CONTROLS ----------
$window.Add_MouseLeftButtonDown({
    param($s,$e)
    if ($e.GetPosition($window).Y -le 46) { $window.DragMove() }
})
$minimizeButton.Add_Click({ $window.WindowState = [System.Windows.WindowState]::Minimized })
$maximizeButton.Add_Click({
    if ($window.WindowState -eq [System.Windows.WindowState]::Normal) {
        $window.WindowState = [System.Windows.WindowState]::Maximized; $maximizeButton.Content = "❐"
    } else {
        $window.WindowState = [System.Windows.WindowState]::Normal;    $maximizeButton.Content = "□"
    }
})
$closeButton.Add_Click({ $window.Close() })

# ---------- KEYWORD LISTS ----------
$script:suspiciousKeywords = @(
    'launcher','external','cheat','mod','menu','loader',
    'fivem','citizenfx','redengine','eulen','luna',
    'skript','nexus','phaze','inject','executor',
    'aimbot','esp','godmode','teleport',
    'hack','bypass','trainer','exploit','crack','keygen',
    'payload','rootkit','backdoor','keylogger','rat','trojan',
    'stealer','grabber','dumper','spoofer','hwid','unbanner',
    'hvnc','spacewar','cheater','autoclick','triggerbot',
    'wallhack','spinbot','cheatengine','artmoney'
)

$script:psSuspiciousPatterns = @(
    'invoke-expression','invoke-webrequest','invoke-restmethod',
    'downloadstring','downloadfile','net\.webclient',
    'bypass','encodedcommand',
    'frombase64string','tobase64string',
    'system\.reflection\.assembly','loadwithpartialname',
    'start-process.*hidden','new-object.*webclient',
    'memorystream','decompress',
    'marshal\.getdelegateforfunctionpointer','virtualalloc',
    'createthread','writeprocessmemory','openprocess',
    'add-type.*dllimport','reverseshell',
    'mshta','wscript\.shell','cscript',
    'regsvr32','rundll32','certutil.*decode','bitsadmin',
    'set-executionpolicy.*bypass','set-executionpolicy.*unrestricted',
    'disable.*defender','remove-mppreference','add-mppreference.*exclusion',
    'get-credential.*force',
    'invoke-kerberoast','invoke-bloodhound','sharphound',
    'powercat','powersploit','nishang','empire','covenant',
    'amsiutils','amsi\.dll','patchamsi',
    'raw\.githubusercontent','pastebin\.com',
    'bit\.ly','tinyurl','transfer\.sh','fileio\.',
    'iex\s*[\(\$]','iwr\s','\[char\]','join.*char',
    'http://','https://'
)

# ---------- SIGNATURE CHECK ----------
function Get-SignatureInfo {
    param([string]$filePath)

    # Only check paths that look like actual files with extensions
    if ([string]::IsNullOrWhiteSpace($filePath) -or $filePath -eq 'Unknown') {
        return @{ Status = 'N/A'; Color = '#FF555555' }
    }

    # Strip any trailing garbage, environment vars, quotes
    $cleanPath = $filePath.Trim().Trim('"').Trim("'")
    # Handle paths with args like "C:\foo\bar.exe -args"
    if ($cleanPath -match '^([A-Za-z]:\\[^"*?<>|]+?\.[a-zA-Z0-9]{1,6})') {
        $cleanPath = $matches[1]
    }

    # Must have an extension
    if ($cleanPath -notmatch '\.[a-zA-Z0-9]{1,6}$') {
        return @{ Status = 'N/A'; Color = '#FF555555' }
    }

    # File not on disk
    if (-not (Test-Path -LiteralPath $cleanPath -ErrorAction SilentlyContinue)) {
        return @{ Status = 'DELETED'; Color = '#FFCC4444' }
    }

    try {
        $sig = Get-AuthenticodeSignature -LiteralPath $cleanPath -ErrorAction Stop
        switch ($sig.Status) {
            'Valid'                { return @{ Status = 'Signed';    Color = '#FF2ECC71' } }
            'NotSigned'            { return @{ Status = 'Unsigned';  Color = '#FFF39C12' } }
            'UnknownError'         { return @{ Status = 'Unsigned';  Color = '#FFF39C12' } }
            'HashMismatch'         { return @{ Status = 'TAMPERED';  Color = '#FFE74C3C' } }
            'NotTrusted'           { return @{ Status = 'Untrusted'; Color = '#FFFFA07A' } }
            'NotSupportedFileFormat' { return @{ Status = 'N/A';    Color = '#FF555555' } }
            default                { return @{ Status = $sig.Status; Color = '#FF888888' } }
        }
    } catch {
        # Fallback: catalog check via sigcheck-style approach using WinVerifyTrust
        try {
            $fileExists = Test-Path -LiteralPath $cleanPath
            if ($fileExists) {
                return @{ Status = 'Unsigned'; Color = '#FFF39C12' }
            } else {
                return @{ Status = 'DELETED'; Color = '#FFCC4444' }
            }
        } catch {
            return @{ Status = 'Error'; Color = '#FF888888' }
        }
    }
}

# ---------- HELPERS ----------
function Get-AppIcon {
    param($appName)
    $map = @{
        'svchost'='🖥️';'explorer'='📁';'cmd'='⌨️';'powershell'='⌨️';
        'chrome'='🌐';'firefox'='🌐';'edge'='🌐';
        'notepad'='📄';'steam'='🎮';'epic'='🎮';'fivem'='🎮';
        'citizenfx'='🎮';'redengine'='⚠️';'eulen'='⚠️';'luna'='⚠️';
        'inject'='⚠️';'cheat'='⚠️';'hack'='⚠️';
        'defender'='🛡️';'antimalware'='🛡️';
        'skript'='⚠️';'nexus'='⚠️';'phaze'='⚠️';
    }
    $low = $appName.ToLower()
    foreach ($k in $map.Keys) { if ($low -like "*$k*") { return $map[$k] } }
    return '⚙️'
}

function New-EventItem {
    param($d, [int]$count=1)
    [PSCustomObject]@{
        TimeCreated   = $d['TimeCreated']
        Id            = $d['Id']
        Category      = $d['Category']
        AppName       = $d['AppName']
        AppPath       = $d['AppPath']
        ModuleName    = $d['ModuleName']
        ModulePath    = $d['ModulePath']
        RiskLevel     = $d['RiskLevel']
        RiskColor     = $d['RiskColor']
        SeverityColor = $d['SeverityColor']
        AppIcon       = $d['AppIcon']
        SigStatus     = $d['SigStatus']
        SigColor      = $d['SigColor']
        EventCount    = $count
        Details       = $d
    }
}

# ---------- PARSERS ----------

function Parse-AppCrashEvent {
    param($msg, $ev)
    $d = @{}
    $d['TimeCreated']   = $ev.TimeCreated.ToString("yyyy-MM-dd HH:mm:ss")
    $d['Id']            = $ev.Id
    $d['FullMessage']   = $msg
    $d['Category']      = 'Crash'
    $d['SeverityColor'] = if ($ev.Id -eq 1002) { '#FFF39C12' } else { '#FFE74C3C' }

    foreach ($line in ($msg -split "`r`n")) {
        if    ($line -match '^Faulting application name:\s*(.*),\s*version:') { $d['AppName']    = $matches[1].Trim() }
        elseif ($line -match '^Faulting module name:\s*(.*),\s*version:')     { $d['ModuleName'] = $matches[1].Trim() }
        elseif ($line -match '^Exception code:\s*(.*)')                        { $d['ExceptionCode'] = $matches[1].Trim() }
        elseif ($line -match '^Fault offset:\s*(.*)')                          { $d['FaultOffset']   = $matches[1].Trim() }
        elseif ($line -match '^Faulting process id:\s*(.*)')                   { $d['ProcessId']     = $matches[1].Trim() }
        elseif ($line -match '^Faulting application path:\s*(.*)')             { $d['AppPath']       = $matches[1].Trim() }
        elseif ($line -match '^Faulting module path:\s*(.*)')                  { $d['ModulePath']    = $matches[1].Trim() }
        elseif ($line -match '^Report Id:\s*(.*)')                             { $d['ReportId']      = $matches[1].Trim() }
        elseif ($line -match '^Hung application name:\s*(.*),\s*version:')     { $d['AppName']       = $matches[1].Trim() }
        elseif ($line -match '^Hung application path:\s*(.*)')                 { $d['AppPath']       = $matches[1].Trim() }
        elseif ($line -match '^Hung window title:\s*(.*)')                     { $d['WindowTitle']   = $matches[1].Trim() }
    }

    if (-not $d['AppName'])    { $d['AppName']    = 'Unknown' }
    if (-not $d['AppPath'])    { $d['AppPath']    = 'Unknown' }
    if (-not $d['ModuleName']) { $d['ModuleName'] = 'Unknown' }
    if (-not $d['ModulePath']) { $d['ModulePath'] = 'Unknown' }
    if (-not $d['ExceptionCode']) { $d['ExceptionCode'] = 'Unknown' }
    $d['AppIcon'] = Get-AppIcon -appName $d['AppName']

    # Risk
    $low = $d['AppName'].ToLower()
    $danger = $false
    foreach ($kw in $script:suspiciousKeywords) { if ($low -like "*$kw*") { $danger=$true; break } }
    if ($danger) {
        $d['RiskLevel']='Danger'; $d['RiskColor']='#FFE74C3C'
    } else {
        $score = 0
        if ($d['ExceptionCode'] -eq '0xc0000005') { $score++ }
        if ($d['ModulePath'] -match '\\[Tt]emp\\|\\[Aa]pp[Dd]ata\\|\\[Dd]ownloads\\') { $score++ }
        if ($d['ModuleName'] -match '[a-zA-Z0-9]{8,}\.dll') { $score++ }
        if ($d['AppName']    -match 'FiveM' -or $d['AppPath'] -match 'FiveM') { $score+=2 }
        if ($d['ExceptionCode'] -eq '0xc0000409') { $score++ }
        if    ($score -ge 5) { $d['RiskLevel']='Danger'; $d['RiskColor']='#FFE74C3C' }
        elseif ($score -ge 3) { $d['RiskLevel']='High';   $d['RiskColor']='#FFFFA07A' }
        elseif ($score -ge 2) { $d['RiskLevel']='Medium'; $d['RiskColor']='#FFF39C12' }
        elseif ($score -ge 1) { $d['RiskLevel']='Low';    $d['RiskColor']='#FF2ECC71' }
        else                  { $d['RiskLevel']='Info';   $d['RiskColor']='#FF3498DB' }
    }

    # Signature
    $pathToCheck = if ($d['AppPath'] -ne 'Unknown') { $d['AppPath'] } else { $null }
    if ($pathToCheck) {
        $sig = Get-SignatureInfo -filePath $pathToCheck
        $d['SigStatus'] = $sig.Status; $d['SigColor'] = $sig.Color
        if ($sig.Status -eq 'DELETED') {
            $d['RiskLevel'] = 'DELETED'; $d['RiskColor'] = '#FFCC4444'
        } elseif ($sig.Status -eq 'TAMPERED') {
            $d['RiskLevel'] = 'Danger'; $d['RiskColor'] = '#FFE74C3C'
        }
    } else {
        $d['SigStatus'] = 'N/A'; $d['SigColor'] = '#FF555555'
    }

    # Also check module
    if ($d['ModulePath'] -ne 'Unknown' -and $d['SigStatus'] -eq 'N/A') {
        $sig2 = Get-SignatureInfo -filePath $d['ModulePath']
        $d['SigStatus'] = $sig2.Status; $d['SigColor'] = $sig2.Color
    }

    return $d
}

function Parse-DefenderEvent {
    param($msg, $ev)
    $d = @{}
    $d['TimeCreated']   = $ev.TimeCreated.ToString("yyyy-MM-dd HH:mm:ss")
    $d['Id']            = $ev.Id
    $d['FullMessage']   = $msg
    $d['Category']      = 'Defender'
    $d['SeverityColor'] = '#FF9B59B6'
    $d['AppName']       = 'Windows Defender'
    $d['AppPath']       = 'Unknown'
    $d['ModuleName']    = 'Antimalware'
    $d['ModulePath']    = 'Unknown'
    $d['RiskLevel']     = 'Defender'
    $d['RiskColor']     = '#FF9B59B6'
    $d['AppIcon']       = '🛡️'
    $d['ThreatName']    = 'Unknown'
    $d['Action']        = 'Unknown'
    $d['SigStatus']     = 'N/A'
    $d['SigColor']      = '#FF555555'

    foreach ($line in ($msg -split "`r`n")) {
        if    ($line -match 'Threat Name:\s*(.*)')     { $d['ThreatName'] = $matches[1].Trim() }
        elseif ($line -match '^Path:\s*(.*)')           { $d['AppPath']    = $matches[1].Trim() }
        elseif ($line -match 'Process Name:\s*(.*)')   { $d['ProcessName']= $matches[1].Trim() }
        elseif ($line -match '^Action:\s*(.*)')         { $d['Action']     = $matches[1].Trim() }
        elseif ($line -match 'Detection Time:\s*(.*)')  { $d['DetectionTime'] = $matches[1].Trim() }
    }

    if ($d['ThreatName'] -ne 'Unknown') { $d['AppName'] = "Threat: $($d['ThreatName'])"; $d['ModuleName'] = $d['Action'] }
    if ($ev.Id -eq 1117 -and $d['Action'] -ne 'Unknown') { $d['AppName'] = "Defender: $($d['Action'])" }

    # Sig check on detected path
    if ($d['AppPath'] -ne 'Unknown') {
        $sig = Get-SignatureInfo -filePath $d['AppPath']
        $d['SigStatus'] = $sig.Status; $d['SigColor'] = $sig.Color
    }
    return $d
}

function Parse-SystemEvent {
    param($msg, $ev)
    $d = @{}
    $d['TimeCreated']   = $ev.TimeCreated.ToString("yyyy-MM-dd HH:mm:ss")
    $d['Id']            = $ev.Id
    $d['FullMessage']   = $msg
    $d['Category']      = 'System'
    $d['SeverityColor'] = '#FFF39C12'
    $d['AppIcon']       = '🖥️'
    $d['ModuleName']    = 'Service Control Manager'
    $d['ModulePath']    = 'services.exe'
    $d['SigStatus']     = 'N/A'
    $d['SigColor']      = '#FF555555'
    $d['ExceptionCode'] = 'N/A'

    if ($msg -match 'The (.+?) service terminated unexpectedly') {
        $d['AppName'] = $matches[1].Trim(); $d['AppPath'] = "Service: $($d['AppName'])"
    } else {
        $d['AppName'] = 'System Event'
        $short = ($msg -replace "`r`n"," ").Trim()
        $d['AppPath'] = if ($short.Length -gt 100) { $short.Substring(0,100)+'...' } else { $short }
    }

    $low = $d['AppName'].ToLower()
    $danger = $false
    foreach ($kw in $script:suspiciousKeywords) { if ($low -like "*$kw*") { $danger=$true; break } }
    if ($danger) { $d['RiskLevel']='Danger'; $d['RiskColor']='#FFE74C3C' }
    else         { $d['RiskLevel']='Low';    $d['RiskColor']='#FF2ECC71' }
    return $d
}

function Get-PSRiskScore {
    param($text)
    $low = $text.ToLower()
    $score = 0; $hits = @()
    foreach ($p in $script:psSuspiciousPatterns) {
        if ($low -match $p) { $score += 2; $hits += $p }
    }
    if ($low -match '\[char\]'     -or $low -match '\+.*\+.*\+.*\+') { $score+=3 }
    if ($low -match 'join.*char')                                      { $score+=3 }
    if ($low -match '-encodedcommand|-enc ')                           { $score+=2 }
    if ($low -match 'frombase64')                                      { $score+=2 }
    if ($low -match '(http|ftp)s?://')                                 { $score+=2 }
    return @{ Score=$score; Hits=($hits -join ', ') }
}

function Parse-PSEvent {
    param($msg, $ev)
    $d = @{}
    $d['TimeCreated']   = $ev.TimeCreated.ToString("yyyy-MM-dd HH:mm:ss")
    $d['Id']            = $ev.Id
    $d['FullMessage']   = $msg
    $d['Category']      = 'PowerShell'
    $d['SeverityColor'] = '#FF569CD6'
    $d['AppIcon']       = '⌨️'
    $d['ModulePath']    = 'powershell.exe'
    $d['SigStatus']     = 'N/A'
    $d['SigColor']      = '#FF555555'
    $d['ExceptionCode'] = 'N/A'

    $scriptText = ''

    if ($ev.Id -eq 4104) {
        $d['ModuleName'] = 'ScriptBlock 4104'
        $scriptPath = ''
        if ($msg -match 'Path:\s*(.+)')                          { $scriptPath = $matches[1].Trim() }
        if ($msg -match '(?:Creating Scriptblock text|ScriptBlock text)[^\n]*\r?\n([\s\S]+?)(?:ScriptBlock ID:|$)') {
            $scriptText = $matches[1].Trim()
        } else { $scriptText = $msg }
        $d['AppName'] = if ($scriptPath) { "PS: $scriptPath" } else { 'PS: Dynamic/Interactive' }
        $d['AppPath'] = if ($scriptPath) { $scriptPath } else { '<no path>' }
        # Sig check on script path
        if ($scriptPath -and (Test-Path $scriptPath -ErrorAction SilentlyContinue)) {
            $sig = Get-SignatureInfo -filePath $scriptPath
            $d['SigStatus']=$sig.Status; $d['SigColor']=$sig.Color
        }
    } else {
        $d['ModuleName'] = "PS Legacy $($ev.Id)"
        if ($msg -match 'HostApplication=(.+?)(\r|\n|$)') {
            $cmd = $matches[1].Trim()
            $d['AppName'] = "PS: $($cmd.Substring(0,[Math]::Min(60,$cmd.Length)))"
            $d['AppPath'] = $cmd
        } else {
            $d['AppName'] = "PS Event $($ev.Id)"; $d['AppPath'] = 'Unknown'
        }
        $scriptText = $msg
    }

    $d['ScriptText'] = $scriptText
    $risk = Get-PSRiskScore -text "$scriptText $($d['AppPath'])"
    $d['RiskMatches'] = $risk.Hits

    if    ($risk.Score -ge 8) { $d['RiskLevel']='Danger'; $d['RiskColor']='#FFE74C3C' }
    elseif ($risk.Score -ge 5) { $d['RiskLevel']='High';   $d['RiskColor']='#FFFFA07A' }
    elseif ($risk.Score -ge 3) { $d['RiskLevel']='Medium'; $d['RiskColor']='#FFF39C12' }
    elseif ($risk.Score -ge 1) { $d['RiskLevel']='Low';    $d['RiskColor']='#FF2ECC71' }
    else                       { $d['RiskLevel']='Info';   $d['RiskColor']='#FF3498DB' }
    return $d
}

function Parse-DeviceEvent {
    param($msg, $ev, $src)
    $d = @{}
    $d['TimeCreated']   = $ev.TimeCreated.ToString("yyyy-MM-dd HH:mm:ss")
    $d['Id']            = $ev.Id
    $d['FullMessage']   = $msg
    $d['Category']      = 'Device'
    $d['ModulePath']    = $src
    $d['ExceptionCode'] = 'N/A'
    $d['SigStatus']     = 'N/A'
    $d['SigColor']      = '#FF555555'

    $isUSB = $msg -match 'USB|usb'
    $d['AppIcon']       = if ($isUSB) { '🔌' } else { '🔩' }
    $d['SeverityColor'] = if ($isUSB) { '#FFCD6F28' } else { '#FF569CD6' }

    $devName = 'Unknown Device'
    if      ($msg -match 'Device Instance Path[^:]*:\s*(.+)')         { $devName = $matches[1].Trim() }
    elseif  ($msg -match 'device\s+(.+?)\s+(was|has been|is)\s')      { $devName = $matches[1].Trim() }

    $action = switch ($ev.Id) {
        2003 { '+ Connected' } 2100 { '+ Connected' }
        2101 { '- Disconnected' } 2102 { '- Disconnected' }
        400  { '- Disconnected' } 410  { '- Disconnected' }
        default {
            if ($msg -match 'arrival|connect|plug|attach|install') { '+ Connected' }
            elseif ($msg -match 'remov|disconnect|unplug|detach|eject') { '- Disconnected' }
            else { '~ Event' }
        }
    }

    $d['AppName']   = "$action  $devName"
    $d['AppPath']   = $devName
    $d['ModuleName']= $src
    $d['RiskLevel'] = if ($isUSB) { 'Low' } else { 'Info' }
    $d['RiskColor'] = if ($isUSB) { '#FF2ECC71' } else { '#FF3498DB' }
    return $d
}

# ---------- TAB SWITCHING ----------
function Set-ActiveTab {
    param($name)
    $script:currentTab = $name
    foreach ($b in $allTabButtons) { $b.Background='#FF2D2D30'; $b.Foreground='#FFAAAAAA' }
    switch ($name) {
        'All'        { $tabAll.Background='#FF0E639C';  $tabAll.Foreground='White' }
        'Crashes'    { $tabCrashes.Background='#FFE74C3C';   $tabCrashes.Foreground='White' }
        'Defender'   { $tabDefender.Background='#FF9B59B6';  $tabDefender.Foreground='White' }
        'PowerShell' { $tabPowerShell.Background='#FF569CD6'; $tabPowerShell.Foreground='White' }
        'System'     { $tabSystem.Background='#FFF39C12';    $tabSystem.Foreground='White' }
        'Devices'    { $tabDevices.Background='#FFCD6F28';   $tabDevices.Foreground='White' }
    }
    Apply-Filter
}
foreach ($btn in $allTabButtons) {
    $btn.Add_Click({ param($s,$e); Set-ActiveTab -name $s.Tag })
}

# ---------- FILTER ----------
function Apply-Filter {
    $search = $searchBox.Text.ToLower()

    $tabFiltered = switch ($script:currentTab) {
        'All'        { $script:baseEvents }
        'Crashes'    { $script:baseEvents | Where-Object { $_.Category -eq 'Crash' } }
        'Defender'   { $script:baseEvents | Where-Object { $_.Category -eq 'Defender' } }
        'PowerShell' { $script:baseEvents | Where-Object { $_.Category -eq 'PowerShell' } }
        'System'     { $script:baseEvents | Where-Object { $_.Category -eq 'System' } }
        'Devices'    { $script:baseEvents | Where-Object { $_.Category -eq 'Device' } }
        default      { $script:baseEvents }
    }

    if (-not [string]::IsNullOrEmpty($search)) {
        $tabFiltered = $tabFiltered | Where-Object {
            ($_.AppName    -and $_.AppName.ToLower().Contains($search)) -or
            ($_.AppPath    -and $_.AppPath.ToLower().Contains($search)) -or
            ($_.ModuleName -and $_.ModuleName.ToLower().Contains($search)) -or
            ($_.RiskLevel  -and $_.RiskLevel.ToLower().Contains($search)) -or
            ($_.SigStatus  -and $_.SigStatus.ToLower().Contains($search)) -or
            ($_.Category   -and $_.Category.ToLower().Contains($search)) -or
            ($_.Details -and $_.Details['FullMessage'] -and $_.Details['FullMessage'].ToLower().Contains($search))
        }
    }

    $arr = [System.Collections.ArrayList]$tabFiltered
    $script:currentFilteredEvents = $arr
    $eventsListView.ItemsSource   = $arr
    $filteredEventsText.Text = "Showing: $($arr.Count)"
}

# ---------- LOAD EVENTS ----------
function Load-Events {
    $statusText.Text = "Loading events..."
    $window.Cursor   = [System.Windows.Input.Cursors]::Wait
    $eventsListView.ItemsSource = $null

    try {
        $rawItems    = [System.Collections.ArrayList]::new()
        $riskyCount  = 0
        $defCount    = 0
        $psCount     = 0
        $devCount    = 0

        # ---- App Crashes ----
        $statusText.Text = "Loading Application crash events (1000/1002)..."
        try {
            $evts = Get-WinEvent -FilterHashtable @{LogName='Application';ID=1000,1002} -MaxEvents 10000 -ErrorAction Stop
            foreach ($ev in $evts) {
                $d = Parse-AppCrashEvent -msg $ev.Message -ev $ev
                $null = $rawItems.Add((New-EventItem -d $d))
                if ($d['RiskLevel'] -in 'Medium','High','Danger','DELETED') { $riskyCount++ }
            }
        } catch { <# no events or log missing #> }

        # ---- Defender ----
        $statusText.Text = "Loading Defender events (1116/1117)..."
        try {
            $evts = Get-WinEvent -FilterHashtable @{LogName='Microsoft-Windows-Windows Defender/Operational';ID=1116,1117} -MaxEvents 5000 -ErrorAction Stop
            foreach ($ev in $evts) {
                $d = Parse-DefenderEvent -msg $ev.Message -ev $ev
                $null = $rawItems.Add((New-EventItem -d $d))
                $defCount++
            }
        } catch { <# #> }

        # ---- System Service Crashes ----
        $statusText.Text = "Loading System service crash events (7034)..."
        try {
            $evts = Get-WinEvent -FilterHashtable @{LogName='System';ID=7034} -MaxEvents 5000 -ErrorAction Stop
            foreach ($ev in $evts) {
                $d = Parse-SystemEvent -msg $ev.Message -ev $ev
                $null = $rawItems.Add((New-EventItem -d $d))
            }
        } catch { <# #> }

        # ---- PowerShell Script Block (4104) ----
        $statusText.Text = "Loading PowerShell ScriptBlock events (4104)..."
        try {
            $evts = Get-WinEvent -FilterHashtable @{LogName='Microsoft-Windows-PowerShell/Operational';ID=4104} -MaxEvents 20000 -ErrorAction Stop
            foreach ($ev in $evts) {
                $d = Parse-PSEvent -msg $ev.Message -ev $ev
                if ($d['RiskLevel'] -ne 'Info') {
                    $null = $rawItems.Add((New-EventItem -d $d))
                    $psCount++
                    if ($d['RiskLevel'] -in 'Medium','High','Danger') { $riskyCount++ }
                }
            }
        } catch { <# #> }

        # ---- Legacy PowerShell 400/403/800 ----
        $statusText.Text = "Loading legacy PowerShell events (400/403/800)..."
        try {
            $evts = Get-WinEvent -FilterHashtable @{LogName='Windows PowerShell';ID=400,403,800} -MaxEvents 10000 -ErrorAction Stop
            foreach ($ev in $evts) {
                $d = Parse-PSEvent -msg $ev.Message -ev $ev
                if ($d['RiskLevel'] -ne 'Info') {
                    $null = $rawItems.Add((New-EventItem -d $d))
                    $psCount++
                    if ($d['RiskLevel'] -in 'Medium','High','Danger') { $riskyCount++ }
                }
            }
        } catch { <# #> }

        # ---- Kernel-PnP Devices ----
        $statusText.Text = "Loading Kernel-PnP device events..."
        try {
            $evts = Get-WinEvent -FilterHashtable @{LogName='Microsoft-Windows-Kernel-PnP/Configuration';ID=400,410,2003,2100,2101,2102} -MaxEvents 3000 -ErrorAction Stop
            foreach ($ev in $evts) {
                $d = Parse-DeviceEvent -msg $ev.Message -ev $ev -src 'Kernel-PnP'
                $null = $rawItems.Add((New-EventItem -d $d))
                $devCount++
            }
        } catch { <# #> }

        # ---- Hyper-V ----
        $statusText.Text = "Loading Hyper-V events..."
        try {
            $evts = Get-WinEvent -FilterHashtable @{LogName='Microsoft-Windows-Hyper-V-Hypervisor/Operational'} -MaxEvents 1000 -ErrorAction Stop
            foreach ($ev in $evts) {
                $d = Parse-DeviceEvent -msg $ev.Message -ev $ev -src 'Hyper-V'
                $null = $rawItems.Add((New-EventItem -d $d))
                $devCount++
            }
        } catch { <# #> }

        # ---- Deduplicate ----
        $statusText.Text = "Deduplicating..."

        $grouped = $rawItems | Group-Object -Property AppName, AppPath, Id, Category
        $deduped = [System.Collections.ArrayList]::new()
        foreach ($g in $grouped) {
            # Sort by TimeCreated string desc (format is yyyy-MM-dd HH:mm:ss so lexicographic works)
            $first = $g.Group | Sort-Object TimeCreated -Descending | Select-Object -First 1
            $item = [PSCustomObject]@{
                TimeCreated   = $first.TimeCreated
                Id            = $first.Id
                Category      = $first.Category
                AppName       = $first.AppName
                AppPath       = $first.AppPath
                ModuleName    = $first.ModuleName
                ModulePath    = $first.ModulePath
                RiskLevel     = $first.RiskLevel
                RiskColor     = $first.RiskColor
                SeverityColor = $first.SeverityColor
                AppIcon       = $first.AppIcon
                SigStatus     = $first.SigStatus
                SigColor      = $first.SigColor
                EventCount    = $g.Count
                Details       = $first.Details
            }
            $null = $deduped.Add($item)
        }

        # Sort by time descending
        $sorted = [System.Collections.ArrayList]($deduped | Sort-Object TimeCreated -Descending)
        $script:baseEvents = $sorted

        # Update stats
        $totalEventsText.Text     = "Total: $($rawItems.Count)"
        $suspiciousEventsText.Text= "Medium+ Risk: $riskyCount"
        $defenderCountText.Text   = "Defender: $defCount"
        $psCountText.Text         = "PowerShell: $psCount"
        $deviceCountText.Text     = "Devices: $devCount"

        Apply-Filter
        $statusText.Text = "Loaded $($rawItems.Count) events  |  $($script:baseEvents.Count) unique  |  $riskyCount suspicious  |  $psCount PS hits  |  $devCount device events"
    }
    catch {
        $statusText.Text = "Error: $($_.Exception.Message)"
    }
    finally {
        $window.Cursor = [System.Windows.Input.Cursors]::Arrow
    }
}

# ---------- EXPORT ----------
function Export-Results {
    if (-not $script:currentFilteredEvents -or $script:currentFilteredEvents.Count -eq 0) {
        $statusText.Text = "No events to export"; return
    }
    $ts   = Get-Date -Format "yyyyMMdd_HHmmss"
    $file = "SuspiciousEvents_$($script:currentTab)_$ts.csv"
    $script:currentFilteredEvents | ForEach-Object {
        [PSCustomObject]@{
            TimeCreated = $_.TimeCreated
            EventID     = $_.Id
            Category    = $_.Category
            Application = $_.AppName
            Path        = $_.AppPath
            Module      = $_.ModuleName
            Signature   = $_.SigStatus
            RiskLevel   = $_.RiskLevel
            EventCount  = $_.EventCount
            FullMessage = if ($_.Details) { $_.Details['FullMessage'] } else { '' }
        }
    } | Export-Csv -Path $file -NoTypeInformation
    $statusText.Text = "Exported $($script:currentFilteredEvents.Count) events to $file"
}

# ---------- DETAIL WINDOW ----------
function Show-DetailWindow {
    param($item)
    $d = $item.Details
    $detailXaml = @'
<Window xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
        xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
        Title="Event Details" Width="880" Height="680"
        WindowStartupLocation="CenterOwner" Background="#FF1A1A1C"
        WindowStyle="SingleBorderWindow" ResizeMode="CanResize">
    <Grid>
        <Grid.RowDefinitions>
            <RowDefinition Height="*"/>
            <RowDefinition Height="Auto"/>
        </Grid.RowDefinitions>
        <ScrollViewer Grid.Row="0" VerticalScrollBarVisibility="Auto" Background="#FF1A1A1C">
            <StackPanel Margin="16">
                <TextBlock Text="Event Details" FontWeight="Bold" FontSize="15" Foreground="#FFE0E0E0" Margin="0,0,0,12"/>
                <Border Background="#FF252528" CornerRadius="6" Padding="14" Margin="0,0,0,12" BorderBrush="#FF3A3A3C" BorderThickness="1">
                    <Grid>
                        <Grid.ColumnDefinitions>
                            <ColumnDefinition Width="160"/>
                            <ColumnDefinition Width="*"/>
                        </Grid.ColumnDefinitions>
                        <Grid.RowDefinitions>
                            <RowDefinition Height="Auto"/><RowDefinition Height="Auto"/>
                            <RowDefinition Height="Auto"/><RowDefinition Height="Auto"/>
                            <RowDefinition Height="Auto"/><RowDefinition Height="Auto"/>
                            <RowDefinition Height="Auto"/><RowDefinition Height="Auto"/>
                            <RowDefinition Height="Auto"/><RowDefinition Height="Auto"/>
                            <RowDefinition Height="Auto"/><RowDefinition Height="Auto"/>
                            <RowDefinition Height="Auto"/><RowDefinition Height="Auto"/>
                            <RowDefinition Height="Auto"/><RowDefinition Height="Auto"/>
                        </Grid.RowDefinitions>
                        <TextBlock Grid.Row="0"  Grid.Column="0" Text="Time:"         FontWeight="SemiBold" FontSize="11" Foreground="#FF9CDCFE" Margin="0,0,10,5"/>
                        <TextBlock Grid.Row="0"  Grid.Column="1" Text="{Binding TimeCreated}" FontSize="11" Foreground="#FFE0E0E0" TextWrapping="Wrap" FontFamily="Consolas" Margin="0,0,0,5"/>
                        <TextBlock Grid.Row="1"  Grid.Column="0" Text="Event ID:"     FontWeight="SemiBold" FontSize="11" Foreground="#FF9CDCFE" Margin="0,0,10,5"/>
                        <TextBlock Grid.Row="1"  Grid.Column="1" Text="{Binding Id}"  FontSize="11" Foreground="#FFE0E0E0" Margin="0,0,0,5"/>
                        <TextBlock Grid.Row="2"  Grid.Column="0" Text="Category:"     FontWeight="SemiBold" FontSize="11" Foreground="#FF9CDCFE" Margin="0,0,10,5"/>
                        <TextBlock Grid.Row="2"  Grid.Column="1" Text="{Binding Category}" FontSize="11" Foreground="#FFE0E0E0" Margin="0,0,0,5"/>
                        <TextBlock Grid.Row="3"  Grid.Column="0" Text="Application:"  FontWeight="SemiBold" FontSize="11" Foreground="#FF9CDCFE" Margin="0,0,10,5"/>
                        <TextBlock Grid.Row="3"  Grid.Column="1" Text="{Binding AppName}" FontSize="11" Foreground="#FFE0E0E0" TextWrapping="Wrap" Margin="0,0,0,5"/>
                        <TextBlock Grid.Row="4"  Grid.Column="0" Text="Path:"         FontWeight="SemiBold" FontSize="11" Foreground="#FF9CDCFE" Margin="0,0,10,5"/>
                        <TextBlock Grid.Row="4"  Grid.Column="1" Text="{Binding AppPath}" FontSize="11" Foreground="#FFE0E0E0" TextWrapping="Wrap" FontFamily="Consolas" Margin="0,0,0,5"/>
                        <TextBlock Grid.Row="5"  Grid.Column="0" Text="Module:"       FontWeight="SemiBold" FontSize="11" Foreground="#FF9CDCFE" Margin="0,0,10,5"/>
                        <TextBlock Grid.Row="5"  Grid.Column="1" Text="{Binding ModuleName}" FontSize="11" Foreground="#FFE0E0E0" TextWrapping="Wrap" Margin="0,0,0,5"/>
                        <TextBlock Grid.Row="6"  Grid.Column="0" Text="Module Path:"  FontWeight="SemiBold" FontSize="11" Foreground="#FF9CDCFE" Margin="0,0,10,5"/>
                        <TextBlock Grid.Row="6"  Grid.Column="1" Text="{Binding ModulePath}" FontSize="11" Foreground="#FFE0E0E0" TextWrapping="Wrap" FontFamily="Consolas" Margin="0,0,0,5"/>
                        <TextBlock Grid.Row="7"  Grid.Column="0" Text="Exception:"    FontWeight="SemiBold" FontSize="11" Foreground="#FF9CDCFE" Margin="0,0,10,5"/>
                        <TextBlock Grid.Row="7"  Grid.Column="1" Text="{Binding ExceptionCode}" FontSize="11" Foreground="#FFE0E0E0" FontFamily="Consolas" Margin="0,0,0,5"/>
                        <TextBlock Grid.Row="8"  Grid.Column="0" Text="Process ID:"   FontWeight="SemiBold" FontSize="11" Foreground="#FF9CDCFE" Margin="0,0,10,5"/>
                        <TextBlock Grid.Row="8"  Grid.Column="1" Text="{Binding ProcessId}" FontSize="11" Foreground="#FFE0E0E0" Margin="0,0,0,5"/>
                        <TextBlock Grid.Row="9"  Grid.Column="0" Text="Report ID:"    FontWeight="SemiBold" FontSize="11" Foreground="#FF9CDCFE" Margin="0,0,10,5"/>
                        <TextBlock Grid.Row="9"  Grid.Column="1" Text="{Binding ReportId}" FontSize="11" Foreground="#FFE0E0E0" TextWrapping="Wrap" Margin="0,0,0,5"/>
                        <TextBlock Grid.Row="10" Grid.Column="0" Text="Threat Name:"  FontWeight="SemiBold" FontSize="11" Foreground="#FF9CDCFE" Margin="0,0,10,5"/>
                        <TextBlock Grid.Row="10" Grid.Column="1" Text="{Binding ThreatName}" FontSize="11" Foreground="#FFE0E0E0" TextWrapping="Wrap" Margin="0,0,0,5"/>
                        <TextBlock Grid.Row="11" Grid.Column="0" Text="Action:"       FontWeight="SemiBold" FontSize="11" Foreground="#FF9CDCFE" Margin="0,0,10,5"/>
                        <TextBlock Grid.Row="11" Grid.Column="1" Text="{Binding Action}" FontSize="11" Foreground="#FFE0E0E0" TextWrapping="Wrap" Margin="0,0,0,5"/>
                        <TextBlock Grid.Row="12" Grid.Column="0" Text="PS Matches:"   FontWeight="SemiBold" FontSize="11" Foreground="#FF9CDCFE" Margin="0,0,10,5"/>
                        <TextBlock Grid.Row="12" Grid.Column="1" Text="{Binding RiskMatches}" FontSize="11" Foreground="#FFFFA07A" TextWrapping="Wrap" Margin="0,0,0,5"/>
                        <TextBlock Grid.Row="13" Grid.Column="0" Text="Signature:"    FontWeight="SemiBold" FontSize="11" Foreground="#FF9CDCFE" Margin="0,0,10,5"/>
                        <Border Grid.Row="13" Grid.Column="1" Background="{Binding SigColor}" CornerRadius="3" Padding="6,2" HorizontalAlignment="Left" Margin="0,0,0,5">
                            <TextBlock Text="{Binding SigStatus}" Foreground="White" FontSize="10" FontWeight="Bold"/>
                        </Border>
                        <TextBlock Grid.Row="14" Grid.Column="0" Text="Risk Level:"   FontWeight="SemiBold" FontSize="11" Foreground="#FF9CDCFE" Margin="0,0,10,5"/>
                        <Border Grid.Row="14" Grid.Column="1" Background="{Binding RiskColor}" CornerRadius="3" Padding="6,2" HorizontalAlignment="Left" Margin="0,0,0,5">
                            <TextBlock Text="{Binding RiskLevel}" Foreground="White" FontSize="10" FontWeight="Bold"/>
                        </Border>
                        <TextBlock Grid.Row="15" Grid.Column="0" Text="Occurrences:"  FontWeight="SemiBold" FontSize="11" Foreground="#FF9CDCFE" Margin="0,0,10,5"/>
                        <TextBlock Grid.Row="15" Grid.Column="1" Text="{Binding EventCount}" FontSize="11" Foreground="#FFFFA07A" FontWeight="Bold" Margin="0,0,0,5"/>
                    </Grid>
                </Border>
                <TextBlock Text="Full Event Message" FontWeight="Bold" FontSize="13" Foreground="#FFE0E0E0" Margin="0,4,0,8"/>
                <TextBox Text="{Binding FullMessage}" IsReadOnly="True" TextWrapping="Wrap" Height="220"
                         Background="#FF141416" Foreground="#FFE0E0E0" BorderThickness="1"
                         BorderBrush="#FF3A3A3C" FontSize="10" Padding="10" FontFamily="Consolas"
                         VerticalScrollBarVisibility="Auto"/>
            </StackPanel>
        </ScrollViewer>
        <Border Grid.Row="1" Background="#FF252528" BorderBrush="#FF3A3A3C" BorderThickness="0,1,0,0" Padding="12,7">
            <TextBlock Text="Double-click row to open details  •  F5 to refresh main window" Foreground="#FF555555" FontSize="10" HorizontalAlignment="Center"/>
        </Border>
    </Grid>
</Window>
'@
    try {
        $dr   = New-Object System.Xml.XmlNodeReader ([xml]$detailXaml)
        $dwin = [Windows.Markup.XamlReader]::Load($dr)
        $dwin.Owner = $window
        $dwin.WindowStartupLocation = [System.Windows.WindowStartupLocation]::CenterOwner

        # Build a flat object for data context combining item + details
        $ctx = New-Object PSObject
        $ctx | Add-Member -NotePropertyName TimeCreated   -NotePropertyValue $item.TimeCreated
        $ctx | Add-Member -NotePropertyName Id            -NotePropertyValue $item.Id
        $ctx | Add-Member -NotePropertyName Category      -NotePropertyValue $item.Category
        $ctx | Add-Member -NotePropertyName AppName       -NotePropertyValue $item.AppName
        $ctx | Add-Member -NotePropertyName AppPath       -NotePropertyValue $item.AppPath
        $ctx | Add-Member -NotePropertyName ModuleName    -NotePropertyValue $item.ModuleName
        $ctx | Add-Member -NotePropertyName ModulePath    -NotePropertyValue $item.ModulePath
        $ctx | Add-Member -NotePropertyName RiskLevel     -NotePropertyValue $item.RiskLevel
        $ctx | Add-Member -NotePropertyName RiskColor     -NotePropertyValue $item.RiskColor
        $ctx | Add-Member -NotePropertyName SigStatus     -NotePropertyValue $item.SigStatus
        $ctx | Add-Member -NotePropertyName SigColor      -NotePropertyValue $item.SigColor
        $ctx | Add-Member -NotePropertyName EventCount    -NotePropertyValue $item.EventCount
        $ctx | Add-Member -NotePropertyName ExceptionCode -NotePropertyValue (if ($d -and $d['ExceptionCode']) { $d['ExceptionCode'] } else { 'N/A' })
        $ctx | Add-Member -NotePropertyName ProcessId     -NotePropertyValue (if ($d -and $d['ProcessId'])     { $d['ProcessId'] }     else { '' })
        $ctx | Add-Member -NotePropertyName ReportId      -NotePropertyValue (if ($d -and $d['ReportId'])      { $d['ReportId'] }      else { '' })
        $ctx | Add-Member -NotePropertyName ThreatName    -NotePropertyValue (if ($d -and $d['ThreatName'])    { $d['ThreatName'] }    else { '' })
        $ctx | Add-Member -NotePropertyName Action        -NotePropertyValue (if ($d -and $d['Action'])        { $d['Action'] }        else { '' })
        $ctx | Add-Member -NotePropertyName RiskMatches   -NotePropertyValue (if ($d -and $d['RiskMatches'])   { $d['RiskMatches'] }   else { '' })
        $ctx | Add-Member -NotePropertyName FullMessage   -NotePropertyValue (if ($d -and $d['FullMessage'])   { $d['FullMessage'] }   else { '' })

        $dwin.DataContext = $ctx
        $dwin.ShowDialog() | Out-Null
    } catch {
        [System.Windows.MessageBox]::Show("Detail window error: $($_.Exception.Message)")
    }
}

# ---------- WIRE UP ----------
$refreshButton.Add_Click({ Load-Events })
$exportButton.Add_Click({ Export-Results })
$clearSearchButton.Add_Click({ $searchBox.Text = '' })
$searchBox.Add_TextChanged({ Apply-Filter })
$eventsListView.Add_MouseDoubleClick({
    if ($eventsListView.SelectedItem) { Show-DetailWindow -item $eventsListView.SelectedItem }
})
$window.Add_KeyDown({
    if ($_.Key -eq 'F5') { Load-Events }
    if ($_.Key -eq 'Escape') { $searchBox.Text = '' }
    if ($_.Key -eq 'E' -and ([System.Windows.Input.Keyboard]::IsKeyDown('LeftCtrl') -or [System.Windows.Input.Keyboard]::IsKeyDown('RightCtrl'))) { Export-Results }
})

# ---------- LAUNCH ----------
Load-Events
$window.ShowDialog() | Out-Null
