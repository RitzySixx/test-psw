# Load required assemblies
Add-Type -AssemblyName PresentationFramework, PresentationCore, WindowsBase, System.Drawing

# Define XAML for the modern WPF GUI
$xaml = @'
<Window xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
        xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
        Title="Suspicious Event Parser" Width="1600" Height="900"
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
                                <Setter TargetName="Border" Property="Opacity" Value="0.85"/>
                            </Trigger>
                            <Trigger Property="IsPressed" Value="True">
                                <Setter TargetName="Border" Property="Opacity" Value="0.7"/>
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
                                <Setter TargetName="Border" Property="Opacity" Value="0.85"/>
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
            <Setter Property="Padding" Value="8,6"/>
            <Setter Property="BorderBrush" Value="#FF404040"/>
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
                <RowDefinition Height="32"/>
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
                        <TextBlock Text="🔍" FontSize="16" VerticalAlignment="Center" Margin="0,0,8,0"/>
                        <TextBlock Text="Suspicious Event Parser" Foreground="#FFE0E0E0" FontSize="14"
                                   FontWeight="SemiBold" VerticalAlignment="Center"/>
                        <Border Background="#FF0E639C" CornerRadius="3" Padding="6,2" Margin="12,0,0,0" VerticalAlignment="Center">
                            <TextBlock Text="v4.0" Foreground="White" FontSize="9" FontWeight="Bold"/>
                        </Border>
                    </StackPanel>
                    <StackPanel Grid.Column="2" Orientation="Horizontal" VerticalAlignment="Center">
                        <Button x:Name="MinimizeButton" Content="─" Width="38" Height="38" Background="Transparent"
                                Foreground="#FFAAAAAA" BorderThickness="0" FontSize="12" Cursor="Hand"
                                Style="{StaticResource RoundedButtonStyle}"/>
                        <Button x:Name="MaximizeButton" Content="□" Width="38" Height="38" Background="Transparent"
                                Foreground="#FFAAAAAA" BorderThickness="0" FontSize="13" Cursor="Hand"
                                Style="{StaticResource RoundedButtonStyle}"/>
                        <Button x:Name="CloseButton" Content="✕" Width="38" Height="38" Background="Transparent"
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
                    <TextBlock Grid.Column="0" Text="🔍" FontSize="13" VerticalAlignment="Center" Margin="0,0,8,0"/>
                    <TextBox x:Name="SearchBox" Grid.Column="1" Background="#FF141416" Foreground="#FFFFFFFF"
                             BorderBrush="#FF4A4A4C" BorderThickness="1" FontSize="12" Padding="8,5"
                             VerticalContentAlignment="Center" Style="{StaticResource RoundedTextBoxStyle}"
                             ToolTip="Search through events..."/>
                    <Button x:Name="RefreshButton" Grid.Column="2" Content="🔄  Refresh"
                            Background="#FF0E639C" Foreground="White" BorderThickness="0"
                            FontSize="12" FontWeight="SemiBold" Padding="14,6" Margin="8,0,0,0"
                            Style="{StaticResource RoundedButtonStyle}" Height="30" Cursor="Hand"
                            ToolTip="Refresh events (F5)"/>
                    <Button x:Name="ExportButton" Grid.Column="3" Content="📊  Export CSV"
                            Background="#FF388A34" Foreground="White" BorderThickness="0"
                            FontSize="12" FontWeight="SemiBold" Padding="14,6" Margin="8,0,0,0"
                            Style="{StaticResource RoundedButtonStyle}" Height="30" Cursor="Hand"
                            ToolTip="Export results to CSV"/>
                    <Button x:Name="ClearSearchButton" Grid.Column="4" Content="✕"
                            Background="#FF4A4A4C" Foreground="White" BorderThickness="0"
                            FontSize="11" FontWeight="Bold" Padding="10,6" Margin="8,0,0,0"
                            Style="{StaticResource RoundedButtonStyle}" Height="30" Cursor="Hand"
                            ToolTip="Clear search"/>
                </Grid>
            </Border>

            <!-- Tab Bar -->
            <Border Grid.Row="2" Background="#FF1A1A1C" Margin="10,6,10,0">
                <StackPanel Orientation="Horizontal">
                    <Button x:Name="TabAll" Content="🗂  All Events" Tag="All"
                            Background="#FF0E639C" Foreground="White" BorderThickness="0"
                            FontSize="11" FontWeight="SemiBold" Padding="14,7" Margin="0,0,3,0"
                            Style="{StaticResource TabButtonStyle}" Height="32" Cursor="Hand"/>
                    <Button x:Name="TabCrashes" Content="💥  Crashes" Tag="Crashes"
                            Background="#FF2D2D30" Foreground="#FFAAAAAA" BorderThickness="0"
                            FontSize="11" FontWeight="SemiBold" Padding="14,7" Margin="0,0,3,0"
                            Style="{StaticResource TabButtonStyle}" Height="32" Cursor="Hand"/>
                    <Button x:Name="TabDefender" Content="🛡  Defender" Tag="Defender"
                            Background="#FF2D2D30" Foreground="#FFAAAAAA" BorderThickness="0"
                            FontSize="11" FontWeight="SemiBold" Padding="14,7" Margin="0,0,3,0"
                            Style="{StaticResource TabButtonStyle}" Height="32" Cursor="Hand"/>
                    <Button x:Name="TabPowerShell" Content="⌨  PowerShell" Tag="PowerShell"
                            Background="#FF2D2D30" Foreground="#FFAAAAAA" BorderThickness="0"
                            FontSize="11" FontWeight="SemiBold" Padding="14,7" Margin="0,0,3,0"
                            Style="{StaticResource TabButtonStyle}" Height="32" Cursor="Hand"/>
                    <Button x:Name="TabSystem" Content="🖥  System" Tag="System"
                            Background="#FF2D2D30" Foreground="#FFAAAAAA" BorderThickness="0"
                            FontSize="11" FontWeight="SemiBold" Padding="14,7" Margin="0,0,3,0"
                            Style="{StaticResource TabButtonStyle}" Height="32" Cursor="Hand"/>
                    <Button x:Name="TabDevices" Content="🔌  Devices / USB" Tag="Devices"
                            Background="#FF2D2D30" Foreground="#FFAAAAAA" BorderThickness="0"
                            FontSize="11" FontWeight="SemiBold" Padding="14,7" Margin="0,0,3,0"
                            Style="{StaticResource TabButtonStyle}" Height="32" Cursor="Hand"/>
                </StackPanel>
            </Border>

            <!-- Main Content -->
            <Border Grid.Row="3" Background="#FF1A1A1C" Margin="10,0,10,8" CornerRadius="0,0,6,6"
                    BorderBrush="#FF3A3A3C" BorderThickness="1">
                <Grid>
                    <Grid.RowDefinitions>
                        <RowDefinition Height="Auto"/>
                        <RowDefinition Height="*"/>
                    </Grid.RowDefinitions>

                    <!-- Stats Bar -->
                    <Border Grid.Row="0" Background="#FF222226" Margin="8,8,8,4" CornerRadius="4"
                            BorderBrush="#FF3A3A3C" BorderThickness="1">
                        <StackPanel Orientation="Horizontal" Margin="10,5">
                            <StackPanel Orientation="Horizontal" Margin="0,0,18,0">
                                <TextBlock Text="📊" FontSize="11" VerticalAlignment="Center" Margin="0,0,5,0"/>
                                <TextBlock x:Name="TotalEventsText" Text="Total: 0" Foreground="#FFBBBBBB" FontSize="11" VerticalAlignment="Center"/>
                            </StackPanel>
                            <StackPanel Orientation="Horizontal" Margin="0,0,18,0">
                                <TextBlock Text="⚠️" FontSize="11" VerticalAlignment="Center" Margin="0,0,5,0"/>
                                <TextBlock x:Name="SuspiciousEventsText" Text="Medium+ Risk: 0" Foreground="#FFFF6B6B" FontSize="11" VerticalAlignment="Center"/>
                            </StackPanel>
                            <StackPanel Orientation="Horizontal" Margin="0,0,18,0">
                                <TextBlock Text="👁" FontSize="11" VerticalAlignment="Center" Margin="0,0,5,0"/>
                                <TextBlock x:Name="FilteredEventsText" Text="Showing: 0" Foreground="#FF4EC9B0" FontSize="11" VerticalAlignment="Center"/>
                            </StackPanel>
                            <StackPanel Orientation="Horizontal" Margin="0,0,18,0">
                                <TextBlock Text="🛡️" FontSize="11" VerticalAlignment="Center" Margin="0,0,5,0"/>
                                <TextBlock x:Name="DefenderCountText" Text="Defender: 0" Foreground="#FF9B59B6" FontSize="11" VerticalAlignment="Center"/>
                            </StackPanel>
                            <StackPanel Orientation="Horizontal" Margin="0,0,18,0">
                                <TextBlock Text="⌨️" FontSize="11" VerticalAlignment="Center" Margin="0,0,5,0"/>
                                <TextBlock x:Name="PSCountText" Text="PowerShell: 0" Foreground="#FF569CD6" FontSize="11" VerticalAlignment="Center"/>
                            </StackPanel>
                            <StackPanel Orientation="Horizontal">
                                <TextBlock Text="🔌" FontSize="11" VerticalAlignment="Center" Margin="0,0,5,0"/>
                                <TextBlock x:Name="DeviceCountText" Text="Devices: 0" Foreground="#FFFFD700" FontSize="11" VerticalAlignment="Center"/>
                            </StackPanel>
                        </StackPanel>
                    </Border>

                    <!-- Events ListView -->
                    <ListView x:Name="EventsListView" Grid.Row="1" Background="Transparent" Foreground="#FFCCCCCC"
                             BorderThickness="0" ScrollViewer.HorizontalScrollBarVisibility="Auto"
                             ScrollViewer.VerticalScrollBarVisibility="Auto" Margin="8,0,8,8">
                        <ListView.Resources>
                            <Style TargetType="ListViewItem">
                                <Setter Property="Background" Value="Transparent"/>
                                <Setter Property="BorderThickness" Value="0"/>
                                <Setter Property="Padding" Value="6,5"/>
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
                                <GridViewColumn Header="Time" Width="150">
                                    <GridViewColumn.CellTemplate>
                                        <DataTemplate>
                                            <TextBlock Text="{Binding TimeCreated}" Foreground="#FF9CDCFE" FontSize="11"
                                                       FontFamily="Consolas" ToolTip="{Binding TimeCreated}"/>
                                        </DataTemplate>
                                    </GridViewColumn.CellTemplate>
                                </GridViewColumn>
                                <GridViewColumn Header="Event ID" Width="85">
                                    <GridViewColumn.CellTemplate>
                                        <DataTemplate>
                                            <Border Background="{Binding SeverityColor}" CornerRadius="3" Padding="5,2" HorizontalAlignment="Left">
                                                <TextBlock Text="{Binding Id}" Foreground="White" FontSize="10"
                                                           FontWeight="Bold" HorizontalAlignment="Center"/>
                                            </Border>
                                        </DataTemplate>
                                    </GridViewColumn.CellTemplate>
                                </GridViewColumn>
                                <GridViewColumn Header="Category" Width="100">
                                    <GridViewColumn.CellTemplate>
                                        <DataTemplate>
                                            <TextBlock Text="{Binding Category}" Foreground="#FFBBBBBB" FontSize="11"/>
                                        </DataTemplate>
                                    </GridViewColumn.CellTemplate>
                                </GridViewColumn>
                                <GridViewColumn Header="Application / Source" Width="210">
                                    <GridViewColumn.CellTemplate>
                                        <DataTemplate>
                                            <StackPanel Orientation="Horizontal">
                                                <TextBlock Text="{Binding AppIcon}" FontSize="12" VerticalAlignment="Center" Margin="0,0,5,0"/>
                                                <TextBlock Text="{Binding AppName}" Foreground="#FFCCCCCC" FontSize="11"
                                                           TextWrapping="Wrap" ToolTip="{Binding AppName}" VerticalAlignment="Center"/>
                                            </StackPanel>
                                        </DataTemplate>
                                    </GridViewColumn.CellTemplate>
                                </GridViewColumn>
                                <GridViewColumn Header="Path / Detail" Width="270">
                                    <GridViewColumn.CellTemplate>
                                        <DataTemplate>
                                            <TextBlock Text="{Binding AppPath}" Foreground="#FF888888" FontSize="10"
                                                       TextWrapping="Wrap" ToolTip="{Binding AppPath}" FontFamily="Consolas"/>
                                        </DataTemplate>
                                    </GridViewColumn.CellTemplate>
                                </GridViewColumn>
                                <GridViewColumn Header="Module" Width="170">
                                    <GridViewColumn.CellTemplate>
                                        <DataTemplate>
                                            <TextBlock Text="{Binding ModuleName}" Foreground="#FFCCCCCC" FontSize="11"
                                                       TextWrapping="Wrap" ToolTip="{Binding ModuleName}"/>
                                        </DataTemplate>
                                    </GridViewColumn.CellTemplate>
                                </GridViewColumn>
                                <GridViewColumn Header="Module Path" Width="230">
                                    <GridViewColumn.CellTemplate>
                                        <DataTemplate>
                                            <TextBlock Text="{Binding ModulePath}" Foreground="#FF888888" FontSize="10"
                                                       TextWrapping="Wrap" ToolTip="{Binding ModulePath}" FontFamily="Consolas"/>
                                        </DataTemplate>
                                    </GridViewColumn.CellTemplate>
                                </GridViewColumn>
                                <GridViewColumn Header="Risk" Width="90">
                                    <GridViewColumn.CellTemplate>
                                        <DataTemplate>
                                            <Border Background="{Binding RiskColor}" CornerRadius="3" Padding="6,2" HorizontalAlignment="Left">
                                                <TextBlock Text="{Binding RiskLevel}" Foreground="White" FontSize="10"
                                                           FontWeight="Bold" HorizontalAlignment="Center"/>
                                            </Border>
                                        </DataTemplate>
                                    </GridViewColumn.CellTemplate>
                                </GridViewColumn>
                                <GridViewColumn Header="Count" Width="70">
                                    <GridViewColumn.CellTemplate>
                                        <DataTemplate>
                                            <TextBlock Text="{Binding EventCount}" Foreground="#FFFFA07A" FontSize="11"
                                                       HorizontalAlignment="Center" FontWeight="SemiBold"/>
                                        </DataTemplate>
                                    </GridViewColumn.CellTemplate>
                                </GridViewColumn>
                            </GridView>
                        </ListView.View>
                    </ListView>
                </Grid>
            </Border>

            <!-- Status Bar -->
            <Border Grid.Row="4" Background="#FF252528" CornerRadius="0,0,12,12"
                    BorderBrush="#FF3A3A3C" BorderThickness="0,1,0,0">
                <Grid>
                    <TextBlock x:Name="StatusText" Foreground="#FFBBBBBB" FontSize="11" VerticalAlignment="Center"
                               Margin="14,0,0,0" Text="Ready — click Refresh to load events"/>
                    <TextBlock x:Name="VersionText" Foreground="#FF555555" FontSize="10" VerticalAlignment="Center"
                               HorizontalAlignment="Right" Margin="0,0,14,0" Text="v4.0 • Suspicious Event Parser"/>
                </Grid>
            </Border>
        </Grid>
    </Border>
</Window>
'@

# Parse XAML
try {
    $reader = New-Object System.Xml.XmlNodeReader ([xml]$xaml)
    $window = [Windows.Markup.XamlReader]::Load($reader)
} catch {
    Write-Host "Error loading XAML: $($_.Exception.Message)" -ForegroundColor Red
    return
}

# Get controls
$minimizeButton    = $window.FindName("MinimizeButton")
$maximizeButton    = $window.FindName("MaximizeButton")
$closeButton       = $window.FindName("CloseButton")
$refreshButton     = $window.FindName("RefreshButton")
$exportButton      = $window.FindName("ExportButton")
$clearSearchButton = $window.FindName("ClearSearchButton")
$eventsListView    = $window.FindName("EventsListView")
$searchBox         = $window.FindName("SearchBox")
$statusText        = $window.FindName("StatusText")
$totalEventsText   = $window.FindName("TotalEventsText")
$suspiciousEventsText = $window.FindName("SuspiciousEventsText")
$filteredEventsText   = $window.FindName("FilteredEventsText")
$defenderCountText    = $window.FindName("DefenderCountText")
$psCountText          = $window.FindName("PSCountText")
$deviceCountText      = $window.FindName("DeviceCountText")
$titleBar             = $window.FindName("TitleBar")

# Tab buttons
$tabAll        = $window.FindName("TabAll")
$tabCrashes    = $window.FindName("TabCrashes")
$tabDefender   = $window.FindName("TabDefender")
$tabPowerShell = $window.FindName("TabPowerShell")
$tabSystem     = $window.FindName("TabSystem")
$tabDevices    = $window.FindName("TabDevices")

$allTabButtons = @($tabAll, $tabCrashes, $tabDefender, $tabPowerShell, $tabSystem, $tabDevices)

# Script-level state
$script:baseEvents            = @()
$script:currentFilteredEvents = @()
$script:currentTab            = "All"
$script:isDragging            = $false
$script:dragStart             = $null

# ----- DRAGGING -----
$window.Add_MouseLeftButtonDown({
    param($sender, $e)
    $pos = $e.GetPosition($window)
    # Only drag from title bar area (top 46px)
    if ($pos.Y -le 46) {
        $script:isDragging = $true
        $window.DragMove()
    }
})

# ----- WINDOW CONTROLS -----
$minimizeButton.Add_Click({ $window.WindowState = [System.Windows.WindowState]::Minimized })
$maximizeButton.Add_Click({
    if ($window.WindowState -eq [System.Windows.WindowState]::Normal) {
        $window.WindowState = [System.Windows.WindowState]::Maximized
        $maximizeButton.Content = "❐"
    } else {
        $window.WindowState = [System.Windows.WindowState]::Normal
        $maximizeButton.Content = "□"
    }
})
$closeButton.Add_Click({ $window.Close() })

# ----- KEYBOARD SHORTCUTS -----
$window.Add_KeyDown({
    if ($_.Key -eq 'F5') { Load-Events }
    if ($_.Key -eq 'E' -and ([System.Windows.Input.Keyboard]::IsKeyDown('LeftCtrl') -or [System.Windows.Input.Keyboard]::IsKeyDown('RightCtrl'))) {
        Export-Results
    }
    if ($_.Key -eq 'Escape') { $searchBox.Text = "" }
})

# ----- CONSTANTS -----
$script:suspiciousKeywords = @(
    'launcher','settings.cock','external','cheat','mod','menu','loader',
    'fivem','citizenfx','redengine','eulen','luna','hx','9z','tz','crown',
    'skript','nexus','phaze','inject','executor','aimbot','esp','godmode',
    'teleport','dll','hack','bypass','trainer','exploit','crack','keygen',
    'payload','shellcode','rootkit','backdoor','keylogger','rat','trojan',
    'stealer','grabber','dumper','spoofer','hwid','unbanner','hvnc','vac',
    'spacewar','cheater','autoclick','triggerbot','wallhack','spinbot'
)

# Suspicious PowerShell indicators
$script:psSuspiciousPatterns = @(
    'iex\s*\(', 'invoke-expression', 'invoke-webrequest', 'invoke-restmethod',
    'iwr\s', 'downloadstring', 'downloadfile', 'net\.webclient',
    'bypass', 'hidden', 'encodedcommand', '-enc ', '-e ',
    'frombase64string', 'tobase64string', 'system\.reflection\.assembly',
    'loadwithpartialname', '\[convert\]', 'start-process.*-windowstyle.*hidden',
    'new-object.*net\.webclient', 'memorystream', 'decompress',
    'marshal\.getdelegateforfunctionpointer', 'virtualalloc', 'createthread',
    'writeprocessmemory', 'openprocess', 'add-type.*dllimport',
    'reverseshell', 'shellcode', 'mshta', 'wscript', 'cscript',
    'regsvr32', 'rundll32', 'certutil.*decode', 'bitsadmin',
    'set-executionpolicy.*bypass', 'set-executionpolicy.*unrestricted',
    'disable.*defender', 'remove-mppreference', 'add-mppreference.*exclusion',
    'get-credential.*-force', 'mimikatz', 'invoke-mimikatz',
    'invoke-kerberoast', 'invoke-bloodhound', 'sharphound',
    'powercat', 'powersploit', 'nishang', 'empire', 'covenant',
    'amsiutils', 'amsi\.dll', 'patchamsi', '[char]', 'join.*char',
    'http://', 'https://', 'raw\.githubusercontent', 'pastebin\.com',
    'bit\.ly', 'tinyurl', 'fileio\.', 'transfer\.sh'
)

$script:randomRegex = '[a-zA-Z0-9]{8,}(\.exe|\.dll)?'

# ----- TAB SWITCHING -----
function Set-ActiveTab {
    param($tabName)
    $script:currentTab = $tabName

    foreach ($btn in $allTabButtons) {
        $btn.Background = "#FF2D2D30"
        $btn.Foreground = "#FFAAAAAA"
    }

    switch ($tabName) {
        "All"        { $tabAll.Background        = "#FF0E639C"; $tabAll.Foreground        = "White" }
        "Crashes"    { $tabCrashes.Background    = "#FFE74C3C"; $tabCrashes.Foreground    = "White" }
        "Defender"   { $tabDefender.Background   = "#FF9B59B6"; $tabDefender.Foreground   = "White" }
        "PowerShell" { $tabPowerShell.Background = "#FF569CD6"; $tabPowerShell.Foreground = "White" }
        "System"     { $tabSystem.Background     = "#FFF39C12"; $tabSystem.Foreground     = "White" }
        "Devices"    { $tabDevices.Background    = "#FFCD6F28"; $tabDevices.Foreground    = "White" }
    }

    Apply-Filter
}

foreach ($btn in $allTabButtons) {
    $btn.Add_Click({
        param($s, $e)
        Set-ActiveTab -tabName $s.Tag
    })
}

# ----- APPLY FILTER -----
function Apply-Filter {
    $searchText = $searchBox.Text.ToLower()

    $tabFiltered = switch ($script:currentTab) {
        "All"        { $script:baseEvents }
        "Crashes"    { $script:baseEvents | Where-Object { $_.Category -eq "Crash" } }
        "Defender"   { $script:baseEvents | Where-Object { $_.Category -eq "Defender" } }
        "PowerShell" { $script:baseEvents | Where-Object { $_.Category -eq "PowerShell" } }
        "System"     { $script:baseEvents | Where-Object { $_.Category -eq "System" } }
        "Devices"    { $script:baseEvents | Where-Object { $_.Category -eq "Device" } }
        default      { $script:baseEvents }
    }

    if (-not [string]::IsNullOrEmpty($searchText)) {
        $tabFiltered = $tabFiltered | Where-Object {
            ($_.AppName   -and $_.AppName.ToLower().Contains($searchText)) -or
            ($_.AppPath   -and $_.AppPath.ToLower().Contains($searchText)) -or
            ($_.ModuleName -and $_.ModuleName.ToLower().Contains($searchText)) -or
            ($_.ModulePath -and $_.ModulePath.ToLower().Contains($searchText)) -or
            ($_.RiskLevel.ToLower().Contains($searchText)) -or
            ($_.Category  -and $_.Category.ToLower().Contains($searchText)) -or
            ($_.Details -and $_.Details.FullMessage -and $_.Details.FullMessage.ToLower().Contains($searchText))
        }
    }

    $script:currentFilteredEvents = $tabFiltered
    $eventsListView.ItemsSource   = $script:currentFilteredEvents
    $filteredEventsText.Text = "Showing: $($script:currentFilteredEvents.Count)"
}

# ----- ICON HELPER -----
function Get-AppIcon {
    param($appName)
    $icons = @{
        'svchost'    = '🖥️'; 'explorer'  = '📁'; 'cmd'        = '⌨️'; 'powershell' = '⌨️';
        'chrome'     = '🌐'; 'firefox'   = '🌐'; 'edge'       = '🌐';
        'notepad'    = '📄'; 'calculator' = '🔢';
        'steam'      = '🎮'; 'epic'      = '🎮'; 'fivem'      = '🎮';
        'citizenfx'  = '🎮'; 'redengine' = '⚠️'; 'eulen'      = '⚠️'; 'luna'  = '⚠️';
        'hx'         = '⚠️'; '9z'        = '⚠️'; 'tz'         = '⚠️'; 'crown' = '⚠️';
        'skript'     = '⚠️'; 'nexus'     = '⚠️'; 'phaze'      = '⚠️';
        'inject'     = '⚠️'; 'cheat'     = '⚠️'; 'hack'       = '⚠️';
        'defender'   = '🛡️'; 'antimalware' = '🛡️';
    }
    $appLower = $appName.ToLower()
    foreach ($key in $icons.Keys) {
        if ($appLower -like "*$key*") { return $icons[$key] }
    }
    return '⚙️'
}

# ----- PARSE DEFENDER EVENTS -----
function Parse-DefenderEvent {
    param ($message, $event)
    $details = @{}
    $lines = $message -split "`r`n"
    $details['TimeCreated']    = $event.TimeCreated.ToString("yyyy-MM-dd HH:mm:ss")
    $details['Id']             = $event.Id
    $details['FullMessage']    = $message
    $details['SeverityColor']  = "#FF9B59B6"
    $details['AppName']        = 'Windows Defender'
    $details['AppPath']        = 'Unknown'
    $details['ModuleName']     = 'Antimalware Scan'
    $details['ModulePath']     = 'Unknown'
    $details['RiskLevel']      = 'Defender'
    $details['RiskColor']      = "#FF9B59B6"
    $details['AppIcon']        = '🛡️'
    $details['ThreatName']     = 'Unknown'
    $details['Action']         = 'Unknown'
    $details['Category']       = 'Defender'

    foreach ($line in $lines) {
        if    ($line -match 'Threat Name:\s*(.*)')       { $details['ThreatName']  = $matches[1].Trim() }
        elseif ($line -match '^Path:\s*(.*)')            { $details['AppPath']     = $matches[1].Trim() }
        elseif ($line -match 'Process Name:\s*(.*)')     { $details['ProcessName'] = $matches[1].Trim() }
        elseif ($line -match '^Action:\s*(.*)')          { $details['Action']      = $matches[1].Trim() }
        elseif ($line -match 'Action Status:\s*(.*)')    { $details['ActionStatus']= $matches[1].Trim() }
        elseif ($line -match 'Detection Time:\s*(.*)')   { $details['DetectionTime']= $matches[1].Trim() }
        elseif ($line -match 'Error Code:\s*(.*)')       { $details['ErrorCode']   = $matches[1].Trim() }
    }

    if ($details['ThreatName'] -ne 'Unknown') {
        $details['AppName']  = "🛡 $($details['ThreatName'])"
        $details['ModuleName'] = $details['Action']
    }
    if ($event.Id -eq 1117 -and $details['Action'] -ne 'Unknown') {
        $details['AppName'] = "Defender Action: $($details['Action'])"
    }
    return $details
}

# ----- PARSE APPLICATION CRASH EVENTS -----
function Parse-EventMessage {
    param ($message, $event)
    $details = @{}
    $lines   = $message -split "`r`n"

    foreach ($line in $lines) {
        if    ($line -match '^Faulting application name:\s*(.*),\s*version:\s*(.*),\s*time stamp:\s*(.*)') {
            $details['AppName'] = $matches[1].Trim()
        } elseif ($line -match '^Faulting module name:\s*(.*),\s*version:\s*(.*),\s*time stamp:\s*(.*)') {
            $details['ModuleName'] = $matches[1].Trim()
        } elseif ($line -match '^Exception code:\s*(.*)') {
            $details['ExceptionCode'] = $matches[1].Trim()
        } elseif ($line -match '^Fault offset:\s*(.*)') {
            $details['FaultOffset'] = $matches[1].Trim()
        } elseif ($line -match '^Faulting process id:\s*(.*)') {
            $details['ProcessId'] = $matches[1].Trim()
        } elseif ($line -match '^Faulting application path:\s*(.*)') {
            $details['AppPath'] = $matches[1].Trim()
        } elseif ($line -match '^Faulting module path:\s*(.*)') {
            $details['ModulePath'] = $matches[1].Trim()
        } elseif ($line -match '^Report Id:\s*(.*)') {
            $details['ReportId'] = $matches[1].Trim()
        } elseif ($line -match '^Hung application name:\s*(.*),\s*version:') {
            $details['AppName'] = $matches[1].Trim()
        } elseif ($line -match '^Hung application path:\s*(.*)') {
            $details['AppPath'] = $matches[1].Trim()
        } elseif ($line -match '^Hung window title:\s*(.*)') {
            $details['WindowTitle'] = $matches[1].Trim()
        }
    }

    if (-not $details['AppName'])    { $details['AppName']    = 'Unknown' }
    if (-not $details['AppPath'])    { $details['AppPath']    = 'Unknown' }
    if (-not $details['ModuleName']) { $details['ModuleName'] = 'Unknown' }
    if (-not $details['ModulePath']) { $details['ModulePath'] = 'Unknown' }
    if (-not $details['ExceptionCode']) { $details['ExceptionCode'] = 'Unknown' }

    $details['TimeCreated']   = $event.TimeCreated.ToString("yyyy-MM-dd HH:mm:ss")
    $details['Id']            = $event.Id
    $details['FullMessage']   = $message
    $details['SeverityColor'] = if ($event.Id -eq 1002) { "#FFF39C12" } else { "#FFE74C3C" }
    $details['AppIcon']       = Get-AppIcon -appName $details['AppName']
    $details['Category']      = 'Crash'

    # Danger keyword check
    $appNameLower = $details['AppName'].ToLower()
    $isDanger = $false
    foreach ($kw in $script:suspiciousKeywords) {
        if ($appNameLower -like "*$kw*") { $isDanger = $true; break }
    }
    if ($appNameLower -match $script:randomRegex) { $isDanger = $true }

    if ($isDanger) {
        $details['RiskLevel'] = "Danger"
        $details['RiskColor'] = "#FFE74C3C"
    } else {
        $riskScore = 0
        if ($details['ExceptionCode'] -eq '0xc0000005') { $riskScore++ }
        if ($details['ModulePath'] -and ($details['ModulePath'].ToLower() -match '\\temp\\|\\appdata\\|\\downloads\\')) { $riskScore++ }
        if ($details['ModuleName'] -and $details['ModuleName'] -match '[a-zA-Z0-9]{8,}\.dll') { $riskScore++ }
        if ($details['AppName'] -match 'FiveM' -or $details['AppPath'] -match 'FiveM') { $riskScore += 2 }
        if ($details['ExceptionCode'] -eq '0xc0000409') { $riskScore++ }

        if    ($riskScore -ge 5) { $details['RiskLevel'] = "Danger"; $details['RiskColor'] = "#FFE74C3C" }
        elseif ($riskScore -ge 3) { $details['RiskLevel'] = "High";   $details['RiskColor'] = "#FFFFA07A" }
        elseif ($riskScore -ge 2) { $details['RiskLevel'] = "Medium"; $details['RiskColor'] = "#FFF39C12" }
        elseif ($riskScore -ge 1) { $details['RiskLevel'] = "Low";    $details['RiskColor'] = "#FF2ECC71" }
        else                      { $details['RiskLevel'] = "Info";   $details['RiskColor'] = "#FF3498DB" }
    }
    return $details
}

# ----- PARSE SYSTEM EVENT 7034 (Service Crashed) -----
function Parse-SystemEvent {
    param ($message, $event)
    $details = @{}
    $details['TimeCreated']   = $event.TimeCreated.ToString("yyyy-MM-dd HH:mm:ss")
    $details['Id']            = $event.Id
    $details['FullMessage']   = $message
    $details['SeverityColor'] = "#FFF39C12"
    $details['AppIcon']       = '🖥️'
    $details['Category']      = 'System'
    $details['ModuleName']    = 'Service Control Manager'
    $details['ModulePath']    = 'services.exe'

    # 7034: "The X service terminated unexpectedly"
    if ($message -match 'The (.+?) service terminated unexpectedly') {
        $details['AppName'] = $matches[1].Trim()
        $details['AppPath'] = "Service: $($matches[1].Trim())"
    } elseif ($message -match 'service.*terminated') {
        $details['AppName'] = 'Unknown Service'
        $details['AppPath'] = 'Unknown'
    } else {
        $details['AppName'] = 'System Event'
        $details['AppPath'] = $message -replace "`r`n"," " | ForEach-Object { if ($_.Length -gt 120) { $_.Substring(0,120) + "..." } else { $_ } }
    }

    $riskScore = 0
    $nameLower = $details['AppName'].ToLower()
    foreach ($kw in $script:suspiciousKeywords) {
        if ($nameLower -like "*$kw*") { $riskScore += 3; break }
    }

    if    ($riskScore -ge 3) { $details['RiskLevel'] = "Danger"; $details['RiskColor'] = "#FFE74C3C" }
    elseif ($riskScore -ge 2) { $details['RiskLevel'] = "High";   $details['RiskColor'] = "#FFFFA07A" }
    elseif ($riskScore -ge 1) { $details['RiskLevel'] = "Medium"; $details['RiskColor'] = "#FFF39C12" }
    else                      { $details['RiskLevel'] = "Low";    $details['RiskColor'] = "#FF2ECC71" }

    return $details
}

# ----- ASSESS POWERSHELL RISK -----
function Get-PSRisk {
    param($scriptText, $commandLine)
    $combined = "$scriptText $commandLine".ToLower()
    $score = 0
    $matched = @()

    foreach ($pattern in $script:psSuspiciousPatterns) {
        if ($combined -match $pattern) {
            $score += 2
            $matched += $pattern
        }
    }

    # Check for obfuscation signals
    if ($combined -match '\[char\]' -or $combined -match '\+.*\+.*\+.*\+') { $score += 3 }
    if ($combined -match 'join.*\(.*\[char\]') { $score += 3 }
    if ($combined -match '-encodedcommand|-enc ') { $score += 2 }
    if ($combined -match 'frombase64') { $score += 2 }
    if ($combined -match '(http|ftp)s?://') { $score += 2 }

    return @{ Score = $score; Matched = ($matched -join ", ") }
}

# ----- PARSE POWERSHELL EVENTS -----
function Parse-PSEvent {
    param ($message, $event)
    $details = @{}
    $details['TimeCreated']   = $event.TimeCreated.ToString("yyyy-MM-dd HH:mm:ss")
    $details['Id']            = $event.Id
    $details['FullMessage']   = $message
    $details['SeverityColor'] = "#FF569CD6"
    $details['AppIcon']       = '⌨️'
    $details['Category']      = 'PowerShell'
    $details['ModuleName']    = "PowerShell Event $($event.Id)"
    $details['ModulePath']    = 'powershell.exe'

    $scriptText  = ""
    $commandLine = ""
    $scriptPath  = ""

    # Event 4104 - Script block logging
    if ($event.Id -eq 4104) {
        $details['ModuleName'] = "Script Block (4104)"
        if ($message -match 'ScriptBlock ID:\s*([0-9a-f\-]+)') {
            $details['ScriptBlockId'] = $matches[1]
        }
        if ($message -match 'Path:\s*(.+)') {
            $scriptPath = $matches[1].Trim()
        }
        # Extract the script text between "Creating Scriptblock text" and "ScriptBlock ID"
        if ($message -match 'Creating Scriptblock text.*?:\r?\n([\s\S]+?)(?:ScriptBlock ID:|$)') {
            $scriptText = $matches[1].Trim()
        } elseif ($message -match 'ScriptBlock text.*?:\r?\n([\s\S]+?)(?:ScriptBlock ID:|$)') {
            $scriptText = $matches[1].Trim()
        } else {
            $scriptText = $message
        }
        $details['AppName'] = if ($scriptPath -and $scriptPath -ne "") { "PS: $scriptPath" } else { "PS: Interactive/Dynamic" }
        $details['AppPath'] = if ($scriptPath) { $scriptPath } else { "<no path - dynamic execution>" }
    }

    # Events 403 / 800 - Windows PowerShell legacy log
    elseif ($event.Id -in @(400, 403, 800)) {
        $details['ModuleName'] = "PS Legacy ($($event.Id))"
        if ($message -match 'HostApplication=(.+?)(\r|\n|$)') {
            $commandLine = $matches[1].Trim()
            $details['AppName'] = "PS Legacy: $($commandLine.Substring(0, [Math]::Min(60,$commandLine.Length)))"
            $details['AppPath'] = $commandLine
        } else {
            $details['AppName'] = "PS Legacy Event $($event.Id)"
            $details['AppPath'] = 'Unknown'
        }
        $scriptText = $message
    }
    else {
        $scriptText           = $message
        $details['AppName']   = "PS Event $($event.Id)"
        $details['AppPath']   = 'Unknown'
    }

    $details['ScriptText'] = $scriptText
    $details['CommandLine'] = $commandLine

    $risk = Get-PSRisk -scriptText $scriptText -commandLine $commandLine

    if    ($risk.Score -ge 8) { $details['RiskLevel'] = "Danger"; $details['RiskColor'] = "#FFE74C3C" }
    elseif ($risk.Score -ge 5) { $details['RiskLevel'] = "High";   $details['RiskColor'] = "#FFFFA07A" }
    elseif ($risk.Score -ge 3) { $details['RiskLevel'] = "Medium"; $details['RiskColor'] = "#FFF39C12" }
    elseif ($risk.Score -ge 1) { $details['RiskLevel'] = "Low";    $details['RiskColor'] = "#FF2ECC71" }
    else                       { $details['RiskLevel'] = "Info";   $details['RiskColor'] = "#FF3498DB" }

    $details['RiskMatches'] = $risk.Matched

    return $details
}

# ----- PARSE DEVICE EVENTS (Kernel-PnP / Hyper-V) -----
function Parse-DeviceEvent {
    param ($message, $event, $source)
    $details = @{}
    $details['TimeCreated']  = $event.TimeCreated.ToString("yyyy-MM-dd HH:mm:ss")
    $details['Id']           = $event.Id
    $details['FullMessage']  = $message
    $details['Category']     = 'Device'
    $details['ModulePath']   = $source
    $details['ExceptionCode']= 'N/A'

    $isUSB = $message -match 'USB|usb'
    $isGPU = $message -match 'Display|GPU|Video|PCI\\VEN_10DE|PCI\\VEN_1002|PCI\\VEN_8086'

    if ($isUSB) {
        $details['AppIcon']      = '🔌'
        $details['SeverityColor']= "#FFCD6F28"
    } elseif ($isGPU) {
        $details['AppIcon']      = '🖥️'
        $details['SeverityColor']= "#FF569CD6"
    } else {
        $details['AppIcon']      = '🔩'
        $details['SeverityColor']= "#FF888888"
    }

    # Try to get device description from message
    $devName = 'Unknown Device'
    if ($message -match 'device\s+(.+?)\s+(was|has been|is)') {
        $devName = $matches[1].Trim()
    } elseif ($message -match 'Device Instance Path.*?:\s*(.+)') {
        $devName = $matches[1].Trim()
    } elseif ($message -match 'device.*:\s*([A-Za-z0-9\\._&{}\-]+)') {
        $devName = $matches[1].Trim()
    }

    # Determine connect/disconnect from event ID
    $action = switch ($event.Id) {
        2003  { "⬆ Connected" }
        2100  { "⬆ Connected" }
        2101  { "⬇ Disconnected" }
        2102  { "⬇ Disconnected" }
        400   { "⬇ Disconnected" }
        410   { "⬇ Disconnected" }
        default {
            if ($message -match 'arrival|connect|plug|attach|install') { "⬆ Connected" }
            elseif ($message -match 'remov|disconnect|unplug|detach|eject') { "⬇ Disconnected" }
            else { "🔄 Event" }
        }
    }

    $details['AppName']   = "$action — $devName"
    $details['AppPath']   = $devName
    $details['ModuleName']= $source

    # Risk: USB connection is low risk by default; unknown devices get medium
    if ($isUSB) {
        $details['RiskLevel'] = "Low"; $details['RiskColor'] = "#FF2ECC71"
    } else {
        $details['RiskLevel'] = "Info"; $details['RiskColor'] = "#FF3498DB"
    }

    return $details
}

# ----- BUILD LIST ITEM -----
function New-EventItem {
    param($details)
    [PSCustomObject]@{
        TimeCreated   = $details['TimeCreated']
        Id            = $details['Id']
        Category      = $details['Category']
        AppName       = $details['AppName']
        AppPath       = $details['AppPath']
        ModuleName    = $details['ModuleName']
        ModulePath    = $details['ModulePath']
        RiskLevel     = $details['RiskLevel']
        RiskColor     = $details['RiskColor']
        SeverityColor = $details['SeverityColor']
        AppIcon       = $details['AppIcon']
        EventCount    = 1
        Details       = $details
    }
}

# ----- MAIN LOAD FUNCTION -----
function Load-Events {
    $statusText.Text  = "🔄 Loading events — please wait..."
    $window.Cursor    = [System.Windows.Input.Cursors]::Wait
    $eventsListView.ItemsSource = $null

    try {
        $allItems     = @()
        $riskyCount   = 0
        $defCount     = 0
        $psCount      = 0
        $deviceCount  = 0

        # ---- Application Crashes (1000, 1002) ----
        $statusText.Text = "🔄 Loading Application crash events..."
        $appEvents = Get-WinEvent -FilterHashtable @{LogName='Application'; ID=1000,1002} -MaxEvents 10000 -ErrorAction SilentlyContinue
        foreach ($ev in $appEvents) {
            $d = Parse-EventMessage -message $ev.Message -event $ev
            $allItems += New-EventItem -details $d
            if ($d['RiskLevel'] -in @("Medium","High","Danger")) { $riskyCount++ }
        }

        # ---- Windows Defender (1116, 1117) ----
        $statusText.Text = "🔄 Loading Windows Defender events..."
        $defEvents = Get-WinEvent -FilterHashtable @{
            LogName='Microsoft-Windows-Windows Defender/Operational'; ID=1116,1117
        } -MaxEvents 10000 -ErrorAction SilentlyContinue
        foreach ($ev in $defEvents) {
            $d = Parse-DefenderEvent -message $ev.Message -event $ev
            $allItems += New-EventItem -details $d
            $defCount++
        }

        # ---- System Service Crashes (7034) ----
        $statusText.Text = "🔄 Loading System service events..."
        $sysEvents = Get-WinEvent -FilterHashtable @{LogName='System'; ID=7034} -MaxEvents 10000 -ErrorAction SilentlyContinue
        foreach ($ev in $sysEvents) {
            $d = Parse-SystemEvent -message $ev.Message -event $ev
            $allItems += New-EventItem -details $d
        }

        # ---- PowerShell Script Block Logging (4104) ----
        $statusText.Text = "🔄 Loading PowerShell script block events (4104)..."
        $psScriptEvents = Get-WinEvent -FilterHashtable @{
            LogName='Microsoft-Windows-PowerShell/Operational'; ID=4104
        } -MaxEvents 20000 -ErrorAction SilentlyContinue

        foreach ($ev in $psScriptEvents) {
            $d = Parse-PSEvent -message $ev.Message -event $ev
            # Only include if suspicious (score > 0 means at least one indicator found)
            if ($d['RiskLevel'] -ne 'Info') {
                $allItems += New-EventItem -details $d
                $psCount++
                if ($d['RiskLevel'] -in @("Medium","High","Danger")) { $riskyCount++ }
            }
        }

        # ---- Legacy Windows PowerShell (400, 403, 800) ----
        $statusText.Text = "🔄 Loading legacy PowerShell events (400/403/800)..."
        $psLegacyEvents = Get-WinEvent -FilterHashtable @{
            LogName='Windows PowerShell'; ID=400,403,800
        } -MaxEvents 10000 -ErrorAction SilentlyContinue
        foreach ($ev in $psLegacyEvents) {
            $d = Parse-PSEvent -message $ev.Message -event $ev
            if ($d['RiskLevel'] -ne 'Info') {
                $allItems += New-EventItem -details $d
                $psCount++
                if ($d['RiskLevel'] -in @("Medium","High","Danger")) { $riskyCount++ }
            }
        }

        # ---- Kernel-PnP Device Events ----
        $statusText.Text = "🔄 Loading device plug/unplug events..."
        $pnpEvents = Get-WinEvent -FilterHashtable @{
            LogName='Microsoft-Windows-Kernel-PnP/Configuration'; ID=400,410,2003,2100,2101,2102
        } -MaxEvents 5000 -ErrorAction SilentlyContinue
        foreach ($ev in $pnpEvents) {
            $d = Parse-DeviceEvent -message $ev.Message -event $ev -source "Kernel-PnP"
            $allItems += New-EventItem -details $d
            $deviceCount++
        }

        # ---- Hyper-V Hypervisor Events ----
        $statusText.Text = "🔄 Loading Hyper-V events..."
        $hypervEvents = Get-WinEvent -FilterHashtable @{
            LogName='Microsoft-Windows-Hyper-V-Hypervisor/Operational'
        } -MaxEvents 3000 -ErrorAction SilentlyContinue
        foreach ($ev in $hypervEvents) {
            $d = Parse-DeviceEvent -message $ev.Message -event $ev -source "Hyper-V"
            $allItems += New-EventItem -details $d
            $deviceCount++
        }

        # ---- Deduplicate and sort ----
        $statusText.Text = "🔄 Deduplicating and sorting..."
        $grouped = $allItems | Group-Object -Property AppName, AppPath, Id, Category
        $script:baseEvents = $grouped | ForEach-Object {
            $first = $_.Group | Sort-Object { [datetime]::Parse($_.TimeCreated) } -Descending | Select-Object -First 1
            [PSCustomObject]@{
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
                EventCount    = $_.Count
                Details       = $first.Details
            }
        } | Sort-Object { [datetime]::Parse($_.TimeCreated) } -Descending

        $totalCount = $allItems.Count

        # Update stats
        $totalEventsText.Text    = "Total: $totalCount"
        $suspiciousEventsText.Text = "Medium+ Risk: $riskyCount"
        $defenderCountText.Text  = "Defender: $defCount"
        $psCountText.Text        = "PowerShell: $psCount"
        $deviceCountText.Text    = "Devices: $deviceCount"

        Apply-Filter
        $statusText.Text = "✅ Loaded $totalCount raw events ($($script:baseEvents.Count) unique) — $riskyCount suspicious, $psCount PS hits, $deviceCount device events"
    }
    catch {
        $statusText.Text = "❌ Error: $($_.Exception.Message)"
    }
    finally {
        $window.Cursor = [System.Windows.Input.Cursors]::Arrow
    }
}

# ----- EXPORT -----
function Export-Results {
    if (-not $script:currentFilteredEvents -or $script:currentFilteredEvents.Count -eq 0) {
        $statusText.Text = "⚠️ No events to export"
        return
    }
    $timestamp = Get-Date -Format "yyyyMMdd_HHmmss"
    $filename  = "SuspiciousEvents_$($script:currentTab)_$timestamp.csv"
    $script:currentFilteredEvents | ForEach-Object {
        [PSCustomObject]@{
            TimeCreated  = $_.TimeCreated
            EventID      = $_.Id
            Category     = $_.Category
            Application  = $_.AppName
            Path         = $_.AppPath
            Module       = $_.ModuleName
            ModulePath   = $_.ModulePath
            RiskLevel    = $_.RiskLevel
            EventCount   = $_.EventCount
            FullMessage  = $_.Details.FullMessage
        }
    } | Export-Csv -Path $filename -NoTypeInformation
    $statusText.Text = "📁 Exported $($script:currentFilteredEvents.Count) events → $filename"
}

# ----- DETAIL WINDOW -----
function Show-DetailWindow {
    param ($details)
    $detailXaml = @'
<Window xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
        xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
        Title="Event Details" Width="860" Height="650"
        WindowStartupLocation="CenterOwner" Background="#FF1A1A1C"
        WindowStyle="SingleBorderWindow">
    <Border Margin="0" BorderBrush="#FF3A3A3C" BorderThickness="0">
        <Grid>
            <Grid.RowDefinitions>
                <RowDefinition Height="*"/>
                <RowDefinition Height="Auto"/>
            </Grid.RowDefinitions>
            <ScrollViewer Grid.Row="0" VerticalScrollBarVisibility="Auto" Background="#FF1A1A1C">
                <StackPanel Margin="16">
                    <TextBlock Text="📋  Event Details" FontWeight="Bold" FontSize="15" Foreground="#FFE0E0E0" Margin="0,0,0,12"/>
                    <Border Background="#FF252528" CornerRadius="6" Padding="14" Margin="0,0,0,14"
                            BorderBrush="#FF3A3A3C" BorderThickness="1">
                        <Grid>
                            <Grid.ColumnDefinitions>
                                <ColumnDefinition Width="160"/>
                                <ColumnDefinition Width="*"/>
                            </Grid.ColumnDefinitions>
                            <Grid.RowDefinitions>
                                <RowDefinition Height="Auto"/>
                                <RowDefinition Height="Auto"/>
                                <RowDefinition Height="Auto"/>
                                <RowDefinition Height="Auto"/>
                                <RowDefinition Height="Auto"/>
                                <RowDefinition Height="Auto"/>
                                <RowDefinition Height="Auto"/>
                                <RowDefinition Height="Auto"/>
                                <RowDefinition Height="Auto"/>
                                <RowDefinition Height="Auto"/>
                                <RowDefinition Height="Auto"/>
                                <RowDefinition Height="Auto"/>
                                <RowDefinition Height="Auto"/>
                                <RowDefinition Height="Auto"/>
                                <RowDefinition Height="Auto"/>
                            </Grid.RowDefinitions>
                            <TextBlock Grid.Row="0" Grid.Column="0" Text="🕒 Time:" FontWeight="SemiBold" FontSize="11" Foreground="#FF9CDCFE" Margin="0,0,10,6"/>
                            <TextBlock Grid.Row="0" Grid.Column="1" Text="{Binding TimeCreated}" FontSize="11" Foreground="#FFE0E0E0" TextWrapping="Wrap" Margin="0,0,0,6" FontFamily="Consolas"/>
                            <TextBlock Grid.Row="1" Grid.Column="0" Text="🔢 Event ID:" FontWeight="SemiBold" FontSize="11" Foreground="#FF9CDCFE" Margin="0,0,10,6"/>
                            <TextBlock Grid.Row="1" Grid.Column="1" Text="{Binding Id}" FontSize="11" Foreground="#FFE0E0E0" Margin="0,0,0,6"/>
                            <TextBlock Grid.Row="2" Grid.Column="0" Text="🗂 Category:" FontWeight="SemiBold" FontSize="11" Foreground="#FF9CDCFE" Margin="0,0,10,6"/>
                            <TextBlock Grid.Row="2" Grid.Column="1" Text="{Binding Category}" FontSize="11" Foreground="#FFE0E0E0" Margin="0,0,0,6"/>
                            <TextBlock Grid.Row="3" Grid.Column="0" Text="📱 Application:" FontWeight="SemiBold" FontSize="11" Foreground="#FF9CDCFE" Margin="0,0,10,6"/>
                            <TextBlock Grid.Row="3" Grid.Column="1" Text="{Binding AppName}" FontSize="11" Foreground="#FFE0E0E0" TextWrapping="Wrap" Margin="0,0,0,6"/>
                            <TextBlock Grid.Row="4" Grid.Column="0" Text="📁 Path:" FontWeight="SemiBold" FontSize="11" Foreground="#FF9CDCFE" Margin="0,0,10,6"/>
                            <TextBlock Grid.Row="4" Grid.Column="1" Text="{Binding AppPath}" FontSize="11" Foreground="#FFE0E0E0" TextWrapping="Wrap" Margin="0,0,0,6" FontFamily="Consolas"/>
                            <TextBlock Grid.Row="5" Grid.Column="0" Text="🔧 Module:" FontWeight="SemiBold" FontSize="11" Foreground="#FF9CDCFE" Margin="0,0,10,6"/>
                            <TextBlock Grid.Row="5" Grid.Column="1" Text="{Binding ModuleName}" FontSize="11" Foreground="#FFE0E0E0" TextWrapping="Wrap" Margin="0,0,0,6"/>
                            <TextBlock Grid.Row="6" Grid.Column="0" Text="📂 Module Path:" FontWeight="SemiBold" FontSize="11" Foreground="#FF9CDCFE" Margin="0,0,10,6"/>
                            <TextBlock Grid.Row="6" Grid.Column="1" Text="{Binding ModulePath}" FontSize="11" Foreground="#FFE0E0E0" TextWrapping="Wrap" Margin="0,0,0,6" FontFamily="Consolas"/>
                            <TextBlock Grid.Row="7" Grid.Column="0" Text="⚙️ Exception:" FontWeight="SemiBold" FontSize="11" Foreground="#FF9CDCFE" Margin="0,0,10,6"/>
                            <TextBlock Grid.Row="7" Grid.Column="1" Text="{Binding ExceptionCode}" FontSize="11" Foreground="#FFE0E0E0" Margin="0,0,0,6" FontFamily="Consolas"/>
                            <TextBlock Grid.Row="8" Grid.Column="0" Text="🔢 Process ID:" FontWeight="SemiBold" FontSize="11" Foreground="#FF9CDCFE" Margin="0,0,10,6"/>
                            <TextBlock Grid.Row="8" Grid.Column="1" Text="{Binding ProcessId}" FontSize="11" Foreground="#FFE0E0E0" Margin="0,0,0,6"/>
                            <TextBlock Grid.Row="9" Grid.Column="0" Text="📜 Report ID:" FontWeight="SemiBold" FontSize="11" Foreground="#FF9CDCFE" Margin="0,0,10,6"/>
                            <TextBlock Grid.Row="9" Grid.Column="1" Text="{Binding ReportId}" FontSize="11" Foreground="#FFE0E0E0" TextWrapping="Wrap" Margin="0,0,0,6"/>
                            <TextBlock Grid.Row="10" Grid.Column="0" Text="🛡️ Threat:" FontWeight="SemiBold" FontSize="11" Foreground="#FF9CDCFE" Margin="0,0,10,6"/>
                            <TextBlock Grid.Row="10" Grid.Column="1" Text="{Binding ThreatName}" FontSize="11" Foreground="#FFE0E0E0" TextWrapping="Wrap" Margin="0,0,0,6"/>
                            <TextBlock Grid.Row="11" Grid.Column="0" Text="⚡ Action:" FontWeight="SemiBold" FontSize="11" Foreground="#FF9CDCFE" Margin="0,0,10,6"/>
                            <TextBlock Grid.Row="11" Grid.Column="1" Text="{Binding Action}" FontSize="11" Foreground="#FFE0E0E0" TextWrapping="Wrap" Margin="0,0,0,6"/>
                            <TextBlock Grid.Row="12" Grid.Column="0" Text="🔍 PS Matches:" FontWeight="SemiBold" FontSize="11" Foreground="#FF9CDCFE" Margin="0,0,10,6"/>
                            <TextBlock Grid.Row="12" Grid.Column="1" Text="{Binding RiskMatches}" FontSize="11" Foreground="#FFFFA07A" TextWrapping="Wrap" Margin="0,0,0,6"/>
                            <TextBlock Grid.Row="13" Grid.Column="0" Text="⚠️ Risk Level:" FontWeight="SemiBold" FontSize="11" Foreground="#FF9CDCFE" Margin="0,0,10,6"/>
                            <Border Grid.Row="13" Grid.Column="1" Background="{Binding RiskColor}" CornerRadius="3" Padding="7,2" HorizontalAlignment="Left" Margin="0,0,0,6">
                                <TextBlock Text="{Binding RiskLevel}" Foreground="White" FontSize="10" FontWeight="Bold"/>
                            </Border>
                            <TextBlock Grid.Row="14" Grid.Column="0" Text="🔁 Occurrences:" FontWeight="SemiBold" FontSize="11" Foreground="#FF9CDCFE" Margin="0,0,10,6"/>
                            <TextBlock Grid.Row="14" Grid.Column="1" Text="{Binding EventCount}" FontSize="11" Foreground="#FFFFA07A" FontWeight="Bold" Margin="0,0,0,6"/>
                        </Grid>
                    </Border>
                    <TextBlock Text="📜  Full Event Message" FontWeight="Bold" FontSize="14" Foreground="#FFE0E0E0" Margin="0,4,0,8"/>
                    <TextBox Text="{Binding FullMessage}" IsReadOnly="True" TextWrapping="Wrap" Height="200"
                             Background="#FF141416" Foreground="#FFE0E0E0" BorderThickness="1"
                             BorderBrush="#FF3A3A3C" FontSize="10" Padding="10" FontFamily="Consolas"
                             VerticalScrollBarVisibility="Auto"/>
                </StackPanel>
            </ScrollViewer>
            <Border Grid.Row="1" Background="#FF252528" BorderBrush="#FF3A3A3C" BorderThickness="0,1,0,0" Padding="12,8">
                <TextBlock Text="Double-click to copy field values • F5 to refresh main window" Foreground="#FF666666" FontSize="10" HorizontalAlignment="Center"/>
            </Border>
        </Grid>
    </Border>
</Window>
'@

    try {
        $dr   = New-Object System.Xml.XmlNodeReader ([xml]$detailXaml)
        $dwin = [Windows.Markup.XamlReader]::Load($dr)
        $dwin.Owner = $window
        $dwin.WindowStartupLocation = [System.Windows.WindowStartupLocation]::CenterOwner

        $dc = New-Object -TypeName PSObject -Property $details
        # Add EventCount from parent item if not in details
        if (-not $details['EventCount']) { $dc | Add-Member -NotePropertyName EventCount -NotePropertyValue 1 -Force }
        $dwin.DataContext = $dc
        $dwin.ShowDialog() | Out-Null
    } catch {
        Write-Host "Detail window error: $($_.Exception.Message)" -ForegroundColor Red
    }
}

# ----- WIRE UP EVENTS -----
$refreshButton.Add_Click({ Load-Events })
$exportButton.Add_Click({ Export-Results })
$clearSearchButton.Add_Click({ $searchBox.Text = "" })

$searchBox.Add_TextChanged({
    Apply-Filter
})

$eventsListView.Add_MouseDoubleClick({
    if ($eventsListView.SelectedItem) {
        Show-DetailWindow -details $eventsListView.SelectedItem.Details
    }
})

$window.Add_KeyDown({
    if ($_.Key -eq 'F5') { Load-Events }
    if ($_.Key -eq 'Escape') { $searchBox.Text = "" }
    if ($_.Key -eq 'E' -and (
        [System.Windows.Input.Keyboard]::IsKeyDown('LeftCtrl') -or
        [System.Windows.Input.Keyboard]::IsKeyDown('RightCtrl')
    )) { Export-Results }
})

# ----- LAUNCH -----
Load-Events
$window.ShowDialog() | Out-Null
