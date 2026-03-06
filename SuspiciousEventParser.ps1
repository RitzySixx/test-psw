# ============================================================
#  Suspicious Event Parser v4.2
#  - Fixed detail window 'if' operator error
#  - Advanced signature checking (Authenticode + catalog)
#  - Full Defender file detail in Application/Source column
#  - PowerShell risk aligned with Fileless Scanner v10
#  - Base64 / -EncodedCommand = CRITICAL
#  - All log sources wrapped in individual try/catch
# ============================================================
Add-Type -AssemblyName PresentationFramework, PresentationCore, WindowsBase, System.Drawing

$xaml = @'
<Window xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
        xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
        Title="Suspicious Event Parser" Width="1700" Height="940"
        WindowStyle="None" AllowsTransparency="True" Background="Transparent"
        ResizeMode="CanResizeWithGrip" FontFamily="Segoe UI"
        WindowStartupLocation="CenterScreen">
    <Window.Resources>
        <DropShadowEffect x:Key="ShadowEffect" ShadowDepth="4" Direction="320" Color="Black" Opacity="0.55" BlurRadius="22"/>
        <Style x:Key="FlatButton" TargetType="Button">
            <Setter Property="Template">
                <Setter.Value>
                    <ControlTemplate TargetType="Button">
                        <Border x:Name="B" Background="{TemplateBinding Background}" CornerRadius="4"
                                Padding="{TemplateBinding Padding}"
                                BorderThickness="{TemplateBinding BorderThickness}"
                                BorderBrush="{TemplateBinding BorderBrush}">
                            <ContentPresenter HorizontalAlignment="Center" VerticalAlignment="Center"/>
                        </Border>
                        <ControlTemplate.Triggers>
                            <Trigger Property="IsMouseOver" Value="True">
                                <Setter TargetName="B" Property="Opacity" Value="0.80"/>
                            </Trigger>
                            <Trigger Property="IsPressed" Value="True">
                                <Setter TargetName="B" Property="Opacity" Value="0.60"/>
                            </Trigger>
                        </ControlTemplate.Triggers>
                    </ControlTemplate>
                </Setter.Value>
            </Setter>
        </Style>
        <Style x:Key="TabBtn" TargetType="Button">
            <Setter Property="Template">
                <Setter.Value>
                    <ControlTemplate TargetType="Button">
                        <Border x:Name="B" Background="{TemplateBinding Background}" CornerRadius="4,4,0,0"
                                Padding="{TemplateBinding Padding}"
                                BorderThickness="{TemplateBinding BorderThickness}"
                                BorderBrush="{TemplateBinding BorderBrush}">
                            <ContentPresenter HorizontalAlignment="Center" VerticalAlignment="Center"/>
                        </Border>
                        <ControlTemplate.Triggers>
                            <Trigger Property="IsMouseOver" Value="True">
                                <Setter TargetName="B" Property="Opacity" Value="0.80"/>
                            </Trigger>
                        </ControlTemplate.Triggers>
                    </ControlTemplate>
                </Setter.Value>
            </Setter>
        </Style>
        <Style x:Key="RoundTB" TargetType="TextBox">
            <Setter Property="Template">
                <Setter.Value>
                    <ControlTemplate TargetType="TextBox">
                        <Border Background="{TemplateBinding Background}"
                                BorderBrush="{TemplateBinding BorderBrush}"
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

            <!-- ===== TITLE BAR ===== -->
            <Border Grid.Row="0" Background="#FF252528" CornerRadius="12,12,0,0"
                    BorderBrush="#FF3A3A3C" BorderThickness="0,0,0,1">
                <Grid>
                    <Grid.ColumnDefinitions>
                        <ColumnDefinition Width="Auto"/>
                        <ColumnDefinition Width="*"/>
                        <ColumnDefinition Width="Auto"/>
                    </Grid.ColumnDefinitions>
                    <StackPanel Grid.Column="0" Orientation="Horizontal" VerticalAlignment="Center" Margin="15,0,0,0">
                        <TextBlock Text="&#x26A0;" FontSize="15" VerticalAlignment="Center" Margin="0,0,8,0" Foreground="#FFF39C12"/>
                        <TextBlock Text="Suspicious Event Parser" Foreground="#FFE8E8E8" FontSize="14"
                                   FontWeight="SemiBold" VerticalAlignment="Center"/>
                        <Border Background="#FF0E639C" CornerRadius="3" Padding="7,2" Margin="10,0,0,0" VerticalAlignment="Center">
                            <TextBlock Text="v4.2" Foreground="White" FontSize="9" FontWeight="Bold"/>
                        </Border>
                    </StackPanel>
                    <StackPanel Grid.Column="2" Orientation="Horizontal" VerticalAlignment="Center">
                        <Button x:Name="MinimizeButton" Content="&#x2500;" Width="38" Height="38"
                                Background="Transparent" Foreground="#FFB0B0B0" BorderThickness="0"
                                FontSize="12" Cursor="Hand" Style="{StaticResource FlatButton}"/>
                        <Button x:Name="MaximizeButton" Content="&#x25A1;" Width="38" Height="38"
                                Background="Transparent" Foreground="#FFB0B0B0" BorderThickness="0"
                                FontSize="13" Cursor="Hand" Style="{StaticResource FlatButton}"/>
                        <Button x:Name="CloseButton" Content="&#x2715;" Width="38" Height="38"
                                Background="Transparent" Foreground="#FFB0B0B0" BorderThickness="0"
                                FontSize="12" FontWeight="Bold" Cursor="Hand" Style="{StaticResource FlatButton}"/>
                    </StackPanel>
                </Grid>
            </Border>

            <!-- ===== TOOLBAR ===== -->
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
                    <TextBox x:Name="SearchBox" Grid.Column="1" Background="#FF141416" Foreground="White"
                             BorderBrush="#FF4A4A4C" BorderThickness="1" FontSize="12" Padding="8,5"
                             VerticalContentAlignment="Center" Style="{StaticResource RoundTB}"
                             ToolTip="Search events..."/>
                    <Button x:Name="RefreshButton" Grid.Column="2" Content="&#x1F504;  Refresh"
                            Background="#FF0E639C" Foreground="White" BorderThickness="0"
                            FontSize="12" FontWeight="SemiBold" Padding="14,6" Margin="8,0,0,0"
                            Style="{StaticResource FlatButton}" Height="30" Cursor="Hand"/>
                    <Button x:Name="ExportButton" Grid.Column="3" Content="&#x1F4CA;  Export CSV"
                            Background="#FF388A34" Foreground="White" BorderThickness="0"
                            FontSize="12" FontWeight="SemiBold" Padding="14,6" Margin="8,0,0,0"
                            Style="{StaticResource FlatButton}" Height="30" Cursor="Hand"/>
                    <Button x:Name="ClearBtn" Grid.Column="4" Content="&#x2715;"
                            Background="#FF4A4A4C" Foreground="White" BorderThickness="0"
                            FontSize="11" FontWeight="Bold" Padding="10,6" Margin="8,0,0,0"
                            Style="{StaticResource FlatButton}" Height="30" Cursor="Hand"/>
                </Grid>
            </Border>

            <!-- ===== TAB BAR ===== -->
            <Border Grid.Row="2" Background="#FF1A1A1C" Margin="10,6,10,0"
                    BorderBrush="#FF3A3A3C" BorderThickness="0,0,0,1">
                <StackPanel Orientation="Horizontal">
                    <Button x:Name="TabAll"        Content="&#x1F5C2;  All Events"    Tag="All"
                            Background="#FF0E639C"  Foreground="White"      BorderThickness="0"
                            FontSize="11" FontWeight="SemiBold" Padding="14,7" Margin="0,0,3,0"
                            Style="{StaticResource TabBtn}" Height="32" Cursor="Hand"/>
                    <Button x:Name="TabCrashes"    Content="&#x1F4A5;  Crashes"       Tag="Crashes"
                            Background="#FF2D2D30"  Foreground="#FFAAAAAA"  BorderThickness="0"
                            FontSize="11" FontWeight="SemiBold" Padding="14,7" Margin="0,0,3,0"
                            Style="{StaticResource TabBtn}" Height="32" Cursor="Hand"/>
                    <Button x:Name="TabDefender"   Content="&#x1F6E1;  Defender"      Tag="Defender"
                            Background="#FF2D2D30"  Foreground="#FFAAAAAA"  BorderThickness="0"
                            FontSize="11" FontWeight="SemiBold" Padding="14,7" Margin="0,0,3,0"
                            Style="{StaticResource TabBtn}" Height="32" Cursor="Hand"/>
                    <Button x:Name="TabPowerShell" Content="&#x2328;  PowerShell"     Tag="PowerShell"
                            Background="#FF2D2D30"  Foreground="#FFAAAAAA"  BorderThickness="0"
                            FontSize="11" FontWeight="SemiBold" Padding="14,7" Margin="0,0,3,0"
                            Style="{StaticResource TabBtn}" Height="32" Cursor="Hand"/>
                    <Button x:Name="TabSystem"     Content="&#x1F5A5;  System"        Tag="System"
                            Background="#FF2D2D30"  Foreground="#FFAAAAAA"  BorderThickness="0"
                            FontSize="11" FontWeight="SemiBold" Padding="14,7" Margin="0,0,3,0"
                            Style="{StaticResource TabBtn}" Height="32" Cursor="Hand"/>
                    <Button x:Name="TabDevices"    Content="&#x1F50C;  Devices/USB"   Tag="Devices"
                            Background="#FF2D2D30"  Foreground="#FFAAAAAA"  BorderThickness="0"
                            FontSize="11" FontWeight="SemiBold" Padding="14,7" Margin="0,0,3,0"
                            Style="{StaticResource TabBtn}" Height="32" Cursor="Hand"/>
                </StackPanel>
            </Border>

            <!-- ===== MAIN CONTENT ===== -->
            <Border Grid.Row="3" Background="#FF1A1A1C" Margin="10,0,10,8" CornerRadius="0,0,6,6"
                    BorderBrush="#FF3A3A3C" BorderThickness="1,0,1,1">
                <Grid>
                    <Grid.RowDefinitions>
                        <RowDefinition Height="Auto"/>
                        <RowDefinition Height="*"/>
                    </Grid.RowDefinitions>

                    <!-- Stats -->
                    <Border Grid.Row="0" Background="#FF1E1E22" Margin="8,8,8,4" CornerRadius="4"
                            BorderBrush="#FF3A3A3C" BorderThickness="1">
                        <StackPanel Orientation="Horizontal" Margin="12,5">
                            <TextBlock x:Name="TotalTxt"     Text="Total: 0"        Foreground="#FFBBBBBB" FontSize="11" VerticalAlignment="Center" Margin="0,0,18,0"/>
                            <TextBlock x:Name="RiskyTxt"     Text="Risky: 0"        Foreground="#FFFF6B6B" FontSize="11" VerticalAlignment="Center" Margin="0,0,18,0"/>
                            <TextBlock x:Name="ShowingTxt"   Text="Showing: 0"      Foreground="#FF4EC9B0" FontSize="11" VerticalAlignment="Center" Margin="0,0,18,0"/>
                            <TextBlock x:Name="DefTxt"       Text="Defender: 0"     Foreground="#FF9B59B6" FontSize="11" VerticalAlignment="Center" Margin="0,0,18,0"/>
                            <TextBlock x:Name="PSTxt"        Text="PowerShell: 0"   Foreground="#FF569CD6" FontSize="11" VerticalAlignment="Center" Margin="0,0,18,0"/>
                            <TextBlock x:Name="DevTxt"       Text="Devices: 0"      Foreground="#FFFFD700" FontSize="11" VerticalAlignment="Center" Margin="0,0,18,0"/>
                            <TextBlock x:Name="CritTxt"      Text="CRITICAL: 0"     Foreground="#FFFF4444" FontSize="11" FontWeight="Bold" VerticalAlignment="Center"/>
                        </StackPanel>
                    </Border>

                    <!-- ListView -->
                    <ListView x:Name="LV" Grid.Row="1" Background="Transparent" Foreground="#FFCCCCCC"
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
                                        <Setter Property="Background" Value="#FF252530"/>
                                    </Trigger>
                                    <Trigger Property="IsSelected" Value="True">
                                        <Setter Property="Background" Value="#FF0D4070"/>
                                    </Trigger>
                                </Style.Triggers>
                            </Style>
                        </ListView.Resources>
                        <ListView.View>
                            <GridView>
                                <GridViewColumn Header="Time" Width="148">
                                    <GridViewColumn.CellTemplate>
                                        <DataTemplate>
                                            <TextBlock Text="{Binding TimeCreated}" Foreground="#FF9CDCFE"
                                                       FontSize="11" FontFamily="Consolas" ToolTip="{Binding TimeCreated}"/>
                                        </DataTemplate>
                                    </GridViewColumn.CellTemplate>
                                </GridViewColumn>
                                <GridViewColumn Header="ID" Width="68">
                                    <GridViewColumn.CellTemplate>
                                        <DataTemplate>
                                            <Border Background="{Binding SeverityColor}" CornerRadius="3" Padding="4,2">
                                                <TextBlock Text="{Binding Id}" Foreground="White"
                                                           FontSize="10" FontWeight="Bold" HorizontalAlignment="Center"/>
                                            </Border>
                                        </DataTemplate>
                                    </GridViewColumn.CellTemplate>
                                </GridViewColumn>
                                <GridViewColumn Header="Cat" Width="82">
                                    <GridViewColumn.CellTemplate>
                                        <DataTemplate>
                                            <TextBlock Text="{Binding Category}" Foreground="#FFAAAAAA" FontSize="10"/>
                                        </DataTemplate>
                                    </GridViewColumn.CellTemplate>
                                </GridViewColumn>
                                <GridViewColumn Header="Application / Source" Width="220">
                                    <GridViewColumn.CellTemplate>
                                        <DataTemplate>
                                            <StackPanel Orientation="Horizontal">
                                                <TextBlock Text="{Binding AppIcon}" FontSize="11"
                                                           VerticalAlignment="Center" Margin="0,0,4,0"/>
                                                <TextBlock Text="{Binding AppName}" Foreground="#FFE0E0E0"
                                                           FontSize="11" TextWrapping="NoWrap"
                                                           ToolTip="{Binding AppName}" VerticalAlignment="Center"/>
                                            </StackPanel>
                                        </DataTemplate>
                                    </GridViewColumn.CellTemplate>
                                </GridViewColumn>
                                <GridViewColumn Header="Path / Detail" Width="255">
                                    <GridViewColumn.CellTemplate>
                                        <DataTemplate>
                                            <TextBlock Text="{Binding AppPath}" Foreground="#FF888888"
                                                       FontSize="10" TextWrapping="NoWrap"
                                                       ToolTip="{Binding AppPath}" FontFamily="Consolas"/>
                                        </DataTemplate>
                                    </GridViewColumn.CellTemplate>
                                </GridViewColumn>
                                <GridViewColumn Header="Module / Flags" Width="165">
                                    <GridViewColumn.CellTemplate>
                                        <DataTemplate>
                                            <TextBlock Text="{Binding ModuleName}" Foreground="#FFCCCCCC"
                                                       FontSize="11" TextWrapping="NoWrap"
                                                       ToolTip="{Binding ModuleName}"/>
                                        </DataTemplate>
                                    </GridViewColumn.CellTemplate>
                                </GridViewColumn>
                                <GridViewColumn Header="Signature" Width="130">
                                    <GridViewColumn.CellTemplate>
                                        <DataTemplate>
                                            <Border Background="{Binding SigColor}" CornerRadius="3" Padding="5,2" HorizontalAlignment="Left">
                                                <TextBlock Text="{Binding SigStatus}" Foreground="White"
                                                           FontSize="10" FontWeight="SemiBold"/>
                                            </Border>
                                        </DataTemplate>
                                    </GridViewColumn.CellTemplate>
                                </GridViewColumn>
                                <GridViewColumn Header="Risk" Width="88">
                                    <GridViewColumn.CellTemplate>
                                        <DataTemplate>
                                            <Border Background="{Binding RiskColor}" CornerRadius="3" Padding="5,2" HorizontalAlignment="Left">
                                                <TextBlock Text="{Binding RiskLevel}" Foreground="White"
                                                           FontSize="10" FontWeight="Bold"/>
                                            </Border>
                                        </DataTemplate>
                                    </GridViewColumn.CellTemplate>
                                </GridViewColumn>
                                <GridViewColumn Header="Ct" Width="36">
                                    <GridViewColumn.CellTemplate>
                                        <DataTemplate>
                                            <TextBlock Text="{Binding EventCount}" Foreground="#FFFFA07A"
                                                       FontSize="11" HorizontalAlignment="Center" FontWeight="SemiBold"/>
                                        </DataTemplate>
                                    </GridViewColumn.CellTemplate>
                                </GridViewColumn>
                            </GridView>
                        </ListView.View>
                    </ListView>
                </Grid>
            </Border>

            <!-- ===== STATUS BAR ===== -->
            <Border Grid.Row="4" Background="#FF252528" CornerRadius="0,0,12,12"
                    BorderBrush="#FF3A3A3C" BorderThickness="0,1,0,0">
                <Grid>
                    <TextBlock x:Name="StatusText" Foreground="#FFBBBBBB" FontSize="11"
                               VerticalAlignment="Center" Margin="14,0,0,0"
                               Text="Ready — click Refresh to load events"/>
                    <TextBlock Foreground="#FF444444" FontSize="10" VerticalAlignment="Center"
                               HorizontalAlignment="Right" Margin="0,0,14,0"
                               Text="v4.2 • Suspicious Event Parser"/>
                </Grid>
            </Border>
        </Grid>
    </Border>
</Window>
'@

# ============================================================
#  PARSE XAML
# ============================================================
try {
    $reader = New-Object System.Xml.XmlNodeReader ([xml]$xaml)
    $window = [Windows.Markup.XamlReader]::Load($reader)
} catch {
    [System.Windows.MessageBox]::Show("XAML Error: $($_.Exception.Message)")
    return
}

# Controls
$minBtn    = $window.FindName("MinimizeButton")
$maxBtn    = $window.FindName("MaximizeButton")
$closeBtn  = $window.FindName("CloseButton")
$refreshBtn= $window.FindName("RefreshButton")
$exportBtn = $window.FindName("ExportButton")
$clearBtn  = $window.FindName("ClearBtn")
$LV        = $window.FindName("LV")
$searchBox = $window.FindName("SearchBox")
$statusTxt = $window.FindName("StatusText")
$totalTxt  = $window.FindName("TotalTxt")
$riskyTxt  = $window.FindName("RiskyTxt")
$showTxt   = $window.FindName("ShowingTxt")
$defTxt    = $window.FindName("DefTxt")
$psTxt     = $window.FindName("PSTxt")
$devTxt    = $window.FindName("DevTxt")
$critTxt   = $window.FindName("CritTxt")

$tabAll    = $window.FindName("TabAll")
$tabCrash  = $window.FindName("TabCrashes")
$tabDef    = $window.FindName("TabDefender")
$tabPS     = $window.FindName("TabPowerShell")
$tabSys    = $window.FindName("TabSystem")
$tabDev    = $window.FindName("TabDevices")
$allTabs   = @($tabAll,$tabCrash,$tabDef,$tabPS,$tabSys,$tabDev)

# State
$script:baseEvents = @()
$script:filteredEvents = @()
$script:currentTab = "All"

# ============================================================
#  WINDOW WIRING
# ============================================================
$window.Add_MouseLeftButtonDown({
    param($s,$e)
    if ($e.GetPosition($window).Y -le 46) { $window.DragMove() }
})
$minBtn.Add_Click({ $window.WindowState = [System.Windows.WindowState]::Minimized })
$maxBtn.Add_Click({
    if ($window.WindowState -eq [System.Windows.WindowState]::Normal) {
        $window.WindowState = [System.Windows.WindowState]::Maximized
        $maxBtn.Content = [char]0x2750
    } else {
        $window.WindowState = [System.Windows.WindowState]::Normal
        $maxBtn.Content = [char]0x25A1
    }
})
$closeBtn.Add_Click({ $window.Close() })
$window.Add_KeyDown({
    if ($_.Key -eq 'F5')    { Load-Events }
    if ($_.Key -eq 'Escape'){ $searchBox.Text = '' }
    if ($_.Key -eq 'E' -and ([System.Windows.Input.Keyboard]::IsKeyDown('LeftCtrl') -or
                              [System.Windows.Input.Keyboard]::IsKeyDown('RightCtrl'))) { Export-Results }
})

# ============================================================
#  KEYWORD / PATTERN TABLES
# ============================================================
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

# PowerShell suspicious patterns — mirrors Fileless Scanner v10
$script:psPatterns = [ordered]@{
    # CRITICAL — encoded/obfuscated execution
    'encodedcommand'             = @{ Score=10; Label='EncodedCommand';     Sev='CRITICAL' }
    '-enc '                      = @{ Score=10; Label='-enc';               Sev='CRITICAL' }
    'frombase64string'           = @{ Score=10; Label='Base64Decode';       Sev='CRITICAL' }
    'tobase64string'             = @{ Score=8;  Label='Base64Encode';       Sev='CRITICAL' }
    '\[char\]'                   = @{ Score=8;  Label='CharObfuscation';    Sev='CRITICAL' }
    'join.*char'                 = @{ Score=8;  Label='JoinCharObfuscation';Sev='CRITICAL' }
    'patchamsi'                  = @{ Score=10; Label='AMSIBypass';         Sev='CRITICAL' }
    'amsiutils'                  = @{ Score=10; Label='AMSIBypass';         Sev='CRITICAL' }
    'amsi\.dll'                  = @{ Score=10; Label='AMSIBypass';         Sev='CRITICAL' }
    # HIGH — remote exec / download
    'invoke-expression'          = @{ Score=8;  Label='IEX';                Sev='High' }
    'iex\s*[\(\$\[]'             = @{ Score=8;  Label='IEX';                Sev='High' }
    'invoke-webrequest'          = @{ Score=7;  Label='IWR';                Sev='High' }
    'iwr\s'                      = @{ Score=7;  Label='IWR';                Sev='High' }
    'invoke-restmethod'          = @{ Score=7;  Label='IRM';                Sev='High' }
    'irm\s'                      = @{ Score=7;  Label='IRM';                Sev='High' }
    'downloadstring'             = @{ Score=8;  Label='DownloadString';     Sev='High' }
    'downloadfile'               = @{ Score=7;  Label='DownloadFile';       Sev='High' }
    'net\.webclient'             = @{ Score=7;  Label='WebClient';          Sev='High' }
    'new-object.*webclient'      = @{ Score=7;  Label='WebClient';          Sev='High' }
    'raw\.githubusercontent'     = @{ Score=8;  Label='RawGitHub';          Sev='High' }
    'pastebin\.com'              = @{ Score=8;  Label='Pastebin';           Sev='High' }
    'transfer\.sh'               = @{ Score=8;  Label='TransferSh';         Sev='High' }
    'fileio\.'                   = @{ Score=8;  Label='FileIO';             Sev='High' }
    # HIGH — memory injection
    'virtualalloc'               = @{ Score=9;  Label='VirtualAlloc';       Sev='High' }
    'writeprocessmemory'         = @{ Score=9;  Label='WriteProcessMemory'; Sev='High' }
    'createthread'               = @{ Score=9;  Label='CreateThread';       Sev='High' }
    'openprocess'                = @{ Score=9;  Label='OpenProcess';        Sev='High' }
    'marshal\.getdelegateforfunctionpointer' = @{ Score=9; Label='DelegateHook'; Sev='High' }
    'add-type.*dllimport'        = @{ Score=8;  Label='PInvoke';            Sev='High' }
    'system\.reflection\.assembly' = @{ Score=7; Label='ReflectionAssembly';Sev='High' }
    'memorystream'               = @{ Score=6;  Label='MemoryStream';       Sev='High' }
    # HIGH — execution bypass
    'set-executionpolicy.*bypass'= @{ Score=8;  Label='EPBypass';           Sev='High' }
    'set-executionpolicy.*unrestricted'= @{ Score=7; Label='EPUnrestricted';Sev='High' }
    'start-process.*hidden'      = @{ Score=7;  Label='HiddenProcess';      Sev='High' }
    'mshta'                      = @{ Score=8;  Label='MSHTA';              Sev='High' }
    'wscript\.shell'             = @{ Score=7;  Label='WScriptShell';       Sev='High' }
    'regsvr32'                   = @{ Score=7;  Label='Regsvr32';           Sev='High' }
    'rundll32'                   = @{ Score=7;  Label='Rundll32';           Sev='High' }
    'certutil.*decode'           = @{ Score=8;  Label='Certutil';           Sev='High' }
    'bitsadmin'                  = @{ Score=7;  Label='Bitsadmin';          Sev='High' }
    # MEDIUM — AV/Defender tampering
    'remove-mppreference'        = @{ Score=7;  Label='DisableDefender';    Sev='High' }
    'add-mppreference.*exclusion'= @{ Score=7;  Label='DefenderExclusion';  Sev='High' }
    'disable.*defender'          = @{ Score=7;  Label='DisableDefender';    Sev='High' }
    # MEDIUM — known toolkits
    'invoke-mimikatz'            = @{ Score=10; Label='Mimikatz';           Sev='CRITICAL' }
    'invoke-kerberoast'          = @{ Score=9;  Label='Kerberoast';         Sev='CRITICAL' }
    'invoke-bloodhound'          = @{ Score=9;  Label='BloodHound';         Sev='CRITICAL' }
    'sharphound'                 = @{ Score=9;  Label='SharpHound';         Sev='CRITICAL' }
    'powercat'                   = @{ Score=8;  Label='PowerCat';           Sev='High' }
    'powersploit'                = @{ Score=8;  Label='PowerSploit';        Sev='High' }
    'nishang'                    = @{ Score=8;  Label='Nishang';            Sev='High' }
    'covenant'                   = @{ Score=8;  Label='Covenant';           Sev='High' }
    'empire'                     = @{ Score=8;  Label='Empire';             Sev='High' }
    # MEDIUM — generic suspicious
    'curl'                       = @{ Score=3;  Label='Curl';               Sev='Medium' }
    'wget'                       = @{ Score=3;  Label='Wget';               Sev='Medium' }
    'http://'                    = @{ Score=4;  Label='HTTP';               Sev='Medium' }
    'https://'                   = @{ Score=3;  Label='HTTPS';              Sev='Medium' }
    'certutil'                   = @{ Score=4;  Label='Certutil';           Sev='Medium' }
    'new-object'                 = @{ Score=2;  Label='NewObject';          Sev='Low' }
    'compress'                   = @{ Score=3;  Label='Compress';           Sev='Low' }
    'decompress'                 = @{ Score=3;  Label='Decompress';         Sev='Low' }
}

# ============================================================
#  SIMPLE SIGNATURE CHECK (Matches Registry Parser)
# ============================================================
function Get-Signature {
    param([string]$FilePath)

    if ([string]::IsNullOrWhiteSpace($FilePath) -or $FilePath -in @('Unknown','N/A','<no path>','')) {
        return @{ Status = 'N/A'; Color = '#FF555555'; Detail = '' }
    }

    # Clean path — strip quotes, arguments after space following extension
    $clean = $FilePath.Trim().Trim('"').Trim("'")
    if ($clean -match '^([A-Za-z]:\\[^"*?<>|]+?\.[a-zA-Z0-9]{1,6})') {
        $clean = $matches[1]
    }

    # Check if file exists
    $exists = Test-Path -LiteralPath $clean -ErrorAction SilentlyContinue
    
    if (-not $exists) {
        return @{ Status = 'File Was Not Found'; Color = '#FFCC3333'; Detail = "File not found on disk: $clean" }
    }

    try {
        $sig = Get-AuthenticodeSignature -FilePath $clean -ErrorAction SilentlyContinue
        
        $signerName = ''
        if ($sig.SignerCertificate) {
            $signerName = $sig.SignerCertificate.Subject -replace 'CN=','' -replace ',.*',''
        }

        # Match exactly the registry parser's logic
        switch ($sig.Status) {
            'Valid' {
                return @{ Status = 'Valid Signature'; Color = '#FF27AE60'; Detail = "Publisher: $signerName" }
            }
            'NotSigned' {
                return @{ Status = 'Invalid Signature (NotSigned)'; Color = '#FFF39C12'; Detail = 'No Authenticode signature found' }
            }
            'HashMismatch' {
                return @{ Status = 'Invalid Signature (HashMismatch)'; Color = '#FFCC0000'; Detail = 'Hash mismatch — file may be modified' }
            }
            'NotTrusted' {
                return @{ Status = 'Invalid Signature (NotTrusted)'; Color = '#FFFFA040'; Detail = "Cert not trusted: $signerName" }
            }
            'UnknownError' {
                return @{ Status = 'Invalid Signature (UnknownError)'; Color = '#FF888888'; Detail = 'Signature verification error' }
            }
            default {
                return @{ Status = 'Invalid Signature (UnknownError)'; Color = '#FF888888'; Detail = "Status: $($sig.Status)" }
            }
        }
    } catch {
        if (Test-Path -LiteralPath $clean -ErrorAction SilentlyContinue) {
            return @{ Status = 'Invalid Signature (UnknownError)'; Color = '#FF888888'; Detail = "Could not read signature: $($_.Exception.Message)" }
        }
        return @{ Status = 'File Was Not Found'; Color = '#FFCC3333'; Detail = "File not found: $clean" }
    }
}

# ============================================================
#  HELPERS
# ============================================================
function Get-AppIcon {
    param($n)
    $map = @{
        'svchost'='🖥️';'explorer'='📁';'cmd'='⌨️';'powershell'='⌨️';
        'chrome'='🌐';'firefox'='🌐';'edge'='🌐';'notepad'='📄';
        'steam'='🎮';'epic'='🎮';'fivem'='🎮';'citizenfx'='🎮';
        'redengine'='⚠️';'eulen'='⚠️';'luna'='⚠️';
        'inject'='⚠️';'cheat'='⚠️';'hack'='⚠️';
        'defender'='🛡️';'antimalware'='🛡️';
        'skript'='⚠️';'nexus'='⚠️';'phaze'='⚠️';
    }
    $low = $n.ToLower()
    foreach ($k in $map.Keys) { if ($low -like "*$k*") { return $map[$k] } }
    return '⚙️'
}

function Set-RiskFromScore {
    param($d, [int]$score, [string]$forceSev='')

    $sev = $forceSev
    if (-not $sev) {
        if    ($score -ge 10) { $sev = 'CRITICAL' }
        elseif ($score -ge 7) { $sev = 'High' }
        elseif ($score -ge 4) { $sev = 'Medium' }
        elseif ($score -ge 1) { $sev = 'Low' }
        else                  { $sev = 'Info' }
    }

    $colorMap = @{
        'CRITICAL' = '#FFCC0000'
        'High'     = '#FFE74C3C'
        'Medium'   = '#FFFF8C00'
        'Low'      = '#FF2ECC71'
        'Info'     = '#FF3498DB'
        'Defender' = '#FF9B59B6'
        'DELETED'  = '#FFCC3333'
        'TAMPERED' = '#FFCC0000'
    }

    $d['RiskLevel'] = $sev
    $d['RiskColor'] = if ($colorMap.ContainsKey($sev)) { $colorMap[$sev] } else { '#FF888888' }
}

function New-Item-Row {
    param($d, [int]$count = 1)
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

# ============================================================
#  PARSER: APP CRASHES (1000 / 1002)
# ============================================================
function Parse-AppCrash {
    param($msg, $ev)
    $d = @{}
    $d['TimeCreated']   = $ev.TimeCreated.ToString("yyyy-MM-dd HH:mm:ss")
    $d['Id']            = $ev.Id
    $d['FullMessage']   = $msg
    $d['Category']      = 'Crash'
    $d['SeverityColor'] = if ($ev.Id -eq 1002) { '#FFF39C12' } else { '#FFE74C3C' }
    $d['AppName']       = 'Unknown'; $d['AppPath']    = 'Unknown'
    $d['ModuleName']    = 'Unknown'; $d['ModulePath'] = 'Unknown'
    $d['ExceptionCode'] = 'Unknown'; $d['ProcessId']  = ''
    $d['FaultOffset']   = '';        $d['ReportId']   = ''
    $d['WindowTitle']   = '';        $d['RiskMatches']= ''
    $d['ThreatName']    = '';        $d['Action']     = ''
    $d['FlagCount']     = 0;         $d['Severity']   = ''

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

    $d['AppIcon'] = Get-AppIcon -n $d['AppName']

    # Risk scoring
    $low = $d['AppName'].ToLower()
    $danger = $false
    foreach ($kw in $script:suspiciousKeywords) { if ($low -like "*$kw*") { $danger = $true; break } }

    if ($danger) {
        Set-RiskFromScore -d $d -score 99
    } else {
        $score = 0
        if ($d['ExceptionCode'] -eq '0xc0000005')   { $score++ }
        if ($d['ModulePath'] -match '\\[Tt]emp\\|\\[Aa]pp[Dd]ata\\|\\[Dd]ownloads\\') { $score++ }
        if ($d['ModuleName'] -match '[a-zA-Z0-9]{8,}\.dll') { $score++ }
        if ($d['AppName'] -match 'FiveM' -or $d['AppPath'] -match 'FiveM') { $score += 2 }
        if ($d['ExceptionCode'] -eq '0xc0000409')   { $score++ }
        Set-RiskFromScore -d $d -score $score
    }

    # Signature — app path first, fallback module path
    $pathsToTry = @($d['AppPath'], $d['ModulePath']) | Where-Object { $_ -ne 'Unknown' -and $_ -ne '' }
    $sig = @{ Status = 'N/A'; Color = '#FF555555'; Detail = '' }
    foreach ($p in $pathsToTry) {
        $s = Get-Signature -FilePath $p
        if ($s.Status -ne 'N/A') { $sig = $s; break }
    }
    $d['SigStatus'] = $sig.Status; $d['SigColor'] = $sig.Color; $d['SigDetail'] = $sig.Detail

    if ($sig.Status -eq 'DELETED')  { Set-RiskFromScore -d $d -score 0 -forceSev 'DELETED' }
    if ($sig.Status -eq 'TAMPERED') { Set-RiskFromScore -d $d -score 99 }

    return $d
}

# ============================================================
#  PARSER: WINDOWS DEFENDER (1116 / 1117)
# ============================================================
function Parse-Defender {
    param($msg, $ev)
    $d = @{}
    $d['TimeCreated']   = $ev.TimeCreated.ToString("yyyy-MM-dd HH:mm:ss")
    $d['Id']            = $ev.Id
    $d['FullMessage']   = $msg
    $d['Category']      = 'Defender'
    $d['SeverityColor'] = '#FF9B59B6'
    $d['AppIcon']       = '🛡️'
    $d['RiskLevel']     = 'Defender'
    $d['RiskColor']     = '#FF9B59B6'
    $d['ModulePath']    = 'MsMpEng.exe'
    $d['ExceptionCode'] = 'N/A'
    $d['FaultOffset']   = ''; $d['ProcessId']  = ''
    $d['ReportId']      = ''; $d['WindowTitle']= ''
    $d['RiskMatches']   = ''; $d['FlagCount']  = 0
    $d['Severity']      = 'Defender'

    # Defaults
    $d['ThreatName']     = ''
    $d['ThreatId']       = ''
    $d['Action']         = ''
    $d['ActionStatus']   = ''
    $d['DetectedUser']   = ''
    $d['DetectionTime']  = ''
    $d['DetectedPath']   = ''
    $d['ProcessName']    = ''
    $d['ThreatSeverity'] = ''
    $d['ThreatCategory'] = ''
    $d['Origin']         = ''

    foreach ($line in ($msg -split "`r`n")) {
        $line = $line.Trim()
        if    ($line -match '^Threat Name:\s*(.*)')           { $d['ThreatName']     = $matches[1].Trim() }
        elseif ($line -match '^Threat ID:\s*(.*)')             { $d['ThreatId']       = $matches[1].Trim() }
        elseif ($line -match '^Severity:\s*(.*)')              { $d['ThreatSeverity'] = $matches[1].Trim() }
        elseif ($line -match '^Category:\s*(.*)')              { $d['ThreatCategory'] = $matches[1].Trim() }
        elseif ($line -match '^Path:\s*(.*)')                  { $d['DetectedPath']   = $matches[1].Trim() }
        elseif ($line -match '^Detection User:\s*(.*)')        { $d['DetectedUser']   = $matches[1].Trim() }
        elseif ($line -match '^Detection Time:\s*(.*)')        { $d['DetectionTime']  = $matches[1].Trim() }
        elseif ($line -match '^Process Name:\s*(.*)')          { $d['ProcessName']    = $matches[1].Trim() }
        elseif ($line -match '^Action:\s*(.*)')                { $d['Action']         = $matches[1].Trim() }
        elseif ($line -match '^Action Status:\s*(.*)')         { $d['ActionStatus']   = $matches[1].Trim() }
        elseif ($line -match '^Origin Name:\s*(.*)')           { $d['Origin']         = $matches[1].Trim() }
    }

    # Build readable AppName showing threat + action
    $threatPart  = if ($d['ThreatName'])  { $d['ThreatName'] }  else { 'Unknown Threat' }
    $actionPart  = if ($d['Action'])      { " [$($d['Action'])]" } else { '' }
    $sevPart     = if ($d['ThreatSeverity']) { " ($($d['ThreatSeverity']))" } else { '' }
    $d['AppName']  = "$threatPart$sevPart$actionPart"

    # AppPath = the flagged file path (what was detected)
    $d['AppPath']  = if ($d['DetectedPath'] -ne '') { $d['DetectedPath'] } else { 'Unknown' }

    # ModuleName = process that triggered detection
    $d['ModuleName'] = if ($d['ProcessName'] -ne '') { "via: $($d['ProcessName'])" } else { 'Antimalware Scan' }

    # Signature check on the detected file
    $sig = Get-Signature -FilePath $d['DetectedPath']
    $d['SigStatus'] = $sig.Status; $d['SigColor'] = $sig.Color; $d['SigDetail'] = $sig.Detail

    # Set risk based on Defender severity field
    $defSev = $d['ThreatSeverity'].ToLower()
    if    ($defSev -match 'severe|critical') { Set-RiskFromScore -d $d -score 0 -forceSev 'CRITICAL' }
    elseif ($defSev -match 'high')           { Set-RiskFromScore -d $d -score 0 -forceSev 'High' }
    elseif ($defSev -match 'medium|moderate'){ Set-RiskFromScore -d $d -score 0 -forceSev 'Medium' }
    elseif ($defSev -match 'low')            { Set-RiskFromScore -d $d -score 0 -forceSev 'Low' }
    else {
        # Keep Defender color but reclassify 1116 as High
        if ($ev.Id -eq 1116) { Set-RiskFromScore -d $d -score 0 -forceSev 'High' }
        else                 { $d['RiskLevel'] = 'Defender'; $d['RiskColor'] = '#FF9B59B6' }
    }

    return $d
}

# ============================================================
#  PARSER: SYSTEM 7034 (Service crashes)
# ============================================================
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
    $d['SigStatus']     = 'N/A'; $d['SigColor'] = '#FF555555'; $d['SigDetail'] = ''
    $d['ExceptionCode'] = 'N/A'; $d['FaultOffset']= ''; $d['ProcessId'] = ''
    $d['ReportId']      = ''; $d['WindowTitle']= ''; $d['RiskMatches']= ''
    $d['ThreatName']    = ''; $d['Action']     = ''; $d['FlagCount']  = 0
    $d['Severity']      = ''

    if ($msg -match 'The (.+?) service terminated unexpectedly') {
        $d['AppName'] = $matches[1].Trim()
        $d['AppPath'] = "Service: $($d['AppName'])"
    } else {
        $d['AppName'] = 'System Event'
        $short = ($msg -replace "`r`n"," ").Trim()
        $d['AppPath'] = if ($short.Length -gt 120) { $short.Substring(0,120)+'...' } else { $short }
    }

    $low = $d['AppName'].ToLower()
    $danger = $false
    foreach ($kw in $script:suspiciousKeywords) { if ($low -like "*$kw*") { $danger=$true; break } }
    if ($danger) { Set-RiskFromScore -d $d -score 99 }
    else         { Set-RiskFromScore -d $d -score 1 }

    return $d
}

# ============================================================
#  PARSER: POWERSHELL (4104 / 400 / 403 / 800)
# ============================================================
function Get-PSRisk {
    param([string]$text)
    $low    = $text.ToLower()
    $score  = 0
    $flags  = @()
    $topSev = 'Info'
    $sevOrder = @{ 'CRITICAL'=4; 'High'=3; 'Medium'=2; 'Low'=1; 'Info'=0 }

    foreach ($pattern in $script:psPatterns.Keys) {
        if ($low -match $pattern) {
            $info   = $script:psPatterns[$pattern]
            $score += $info.Score
            $flags += $info.Label
            if ($sevOrder[$info.Sev] -gt $sevOrder[$topSev]) { $topSev = $info.Sev }
        }
    }

    return @{ Score=$score; Flags=($flags | Select-Object -Unique); TopSev=$topSev }
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
    $d['SigStatus']     = 'N/A'; $d['SigColor'] = '#FF555555'; $d['SigDetail'] = ''
    $d['ExceptionCode'] = 'N/A'; $d['FaultOffset']= ''; $d['ProcessId'] = ''
    $d['ReportId']      = ''; $d['WindowTitle']= ''
    $d['ThreatName']    = ''; $d['Action']     = ''

    $scriptText  = ''
    $scriptPath  = ''
    $commandLine = ''

    if ($ev.Id -eq 4104) {
        $d['ModuleName'] = 'ScriptBlock (4104)'
        if ($msg -match 'Path:\s*(.+)')  { $scriptPath = $matches[1].Trim() }
        if ($msg -match '(?:Creating Scriptblock text|ScriptBlock text)[^\n]*\r?\n([\s\S]+?)(?:ScriptBlock ID:|$)') {
            $scriptText = $matches[1].Trim()
        } else {
            $scriptText = $msg
        }
        $d['AppPath'] = if ($scriptPath -ne '') { $scriptPath } else { '<dynamic — no path>' }
        # Sig check on script file
        if ($scriptPath -ne '') {
            $sig = Get-Signature -FilePath $scriptPath
            $d['SigStatus']=$sig.Status; $d['SigColor']=$sig.Color; $d['SigDetail']=$sig.Detail
        }
    } else {
        $d['ModuleName'] = "PS Legacy ($($ev.Id))"
        if ($msg -match 'HostApplication=([^\r\n#]+)') {
            $commandLine = $matches[1].Trim() -replace '#$',''
            $d['AppPath'] = $commandLine
            # Try to extract actual exe path from HostApplication
            if ($commandLine -match '^([A-Za-z]:\\[^\s]+\.exe)') {
                $exePath = $matches[1]
                $sig = Get-Signature -FilePath $exePath
                $d['SigStatus']=$sig.Status; $d['SigColor']=$sig.Color; $d['SigDetail']=$sig.Detail
            }
        } else {
            $d['AppPath'] = '<no HostApplication>'
        }
        $scriptText = $msg
    }

    # Risk scoring on ALL content (script text + command + path)
    $allText = "$scriptText $commandLine $scriptPath $($d['AppPath'])"
    $risk = Get-PSRisk -text $allText

    $flagStr = ($risk.Flags -join ' | ')
    $d['RiskMatches'] = $flagStr
    $d['FlagCount']   = $risk.Flags.Count
    $d['Severity']    = $risk.TopSev

    # AppName shows flags inline like Fileless Scanner v10
    if ($scriptPath -ne '' -and $scriptPath -notmatch '<') {
        $leaf = Split-Path -Leaf $scriptPath
        $d['AppName'] = if ($flagStr) { "PS: $leaf  [$flagStr]" } else { "PS: $leaf" }
    } elseif ($commandLine -ne '') {
        $short = if ($commandLine.Length -gt 60) { $commandLine.Substring(0,60)+'...' } else { $commandLine }
        $d['AppName'] = if ($flagStr) { "PS: $short  [$flagStr]" } else { "PS: $short" }
    } else {
        $d['AppName'] = if ($flagStr) { "PS Dynamic [$flagStr]" } else { "PS Dynamic" }
    }

    Set-RiskFromScore -d $d -score $risk.Score -forceSev $risk.TopSev
    if ($risk.TopSev -eq 'Info') { Set-RiskFromScore -d $d -score 0 -forceSev 'Info' }

    return $d
}

# ============================================================
#  PARSER: DEVICES (Kernel-PnP / Hyper-V)
# ============================================================
function Parse-DeviceEvent {
    param($msg, $ev, $src)
    $d = @{}
    $d['TimeCreated']   = $ev.TimeCreated.ToString("yyyy-MM-dd HH:mm:ss")
    $d['Id']            = $ev.Id
    $d['FullMessage']   = $msg
    $d['Category']      = 'Device'
    $d['ModulePath']    = $src
    $d['ExceptionCode'] = 'N/A'; $d['FaultOffset']= ''; $d['ProcessId'] = ''
    $d['ReportId']      = ''; $d['WindowTitle']= ''; $d['RiskMatches']= ''
    $d['ThreatName']    = ''; $d['Action']     = ''; $d['FlagCount']  = 0
    $d['Severity']      = ''; $d['SigDetail']  = ''
    $d['SigStatus']     = 'N/A'; $d['SigColor'] = '#FF555555'

    $isUSB = $msg -match 'USB|usb'
    $d['AppIcon']       = if ($isUSB) { '🔌' } else { '🔩' }
    $d['SeverityColor'] = if ($isUSB) { '#FFCD6F28' } else { '#FF569CD6' }

    $devName = 'Unknown Device'
    if      ($msg -match 'Device Instance Path[^:]*:\s*(.+)')     { $devName = $matches[1].Trim() }
    elseif  ($msg -match 'device\s+(.+?)\s+(was|has been|is)\s')  { $devName = $matches[1].Trim() }

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

    $d['AppName']    = "$action  $devName"
    $d['AppPath']    = $devName
    $d['ModuleName'] = $src
    if ($isUSB) { Set-RiskFromScore -d $d -score 1 }
    else        { Set-RiskFromScore -d $d -score 0 }

    return $d
}

# ============================================================
#  TAB SWITCHING
# ============================================================
function Set-ActiveTab {
    param($name)
    $script:currentTab = $name
    foreach ($b in $allTabs) { $b.Background='#FF2D2D30'; $b.Foreground='#FFAAAAAA' }
    switch ($name) {
        'All'        { $tabAll.Background='#FF0E639C';   $tabAll.Foreground='White' }
        'Crashes'    { $tabCrash.Background='#FFE74C3C'; $tabCrash.Foreground='White' }
        'Defender'   { $tabDef.Background='#FF9B59B6';   $tabDef.Foreground='White' }
        'PowerShell' { $tabPS.Background='#FF569CD6';    $tabPS.Foreground='White' }
        'System'     { $tabSys.Background='#FFF39C12';   $tabSys.Foreground='White' }
        'Devices'    { $tabDev.Background='#FFCD6F28';   $tabDev.Foreground='White' }
    }
    Apply-Filter
}
foreach ($btn in $allTabs) {
    $btn.Add_Click({ param($s,$e); Set-ActiveTab -name $s.Tag })
}

# ============================================================
#  FILTER
# ============================================================
function Apply-Filter {
    $search = $searchBox.Text.ToLower()

    $pool = switch ($script:currentTab) {
        'All'        { $script:baseEvents }
        'Crashes'    { $script:baseEvents | Where-Object { $_.Category -eq 'Crash' } }
        'Defender'   { $script:baseEvents | Where-Object { $_.Category -eq 'Defender' } }
        'PowerShell' { $script:baseEvents | Where-Object { $_.Category -eq 'PowerShell' } }
        'System'     { $script:baseEvents | Where-Object { $_.Category -eq 'System' } }
        'Devices'    { $script:baseEvents | Where-Object { $_.Category -eq 'Device' } }
        default      { $script:baseEvents }
    }

    if (-not [string]::IsNullOrEmpty($search)) {
        $pool = $pool | Where-Object {
            ($_.AppName    -and $_.AppName.ToLower().Contains($search))    -or
            ($_.AppPath    -and $_.AppPath.ToLower().Contains($search))    -or
            ($_.ModuleName -and $_.ModuleName.ToLower().Contains($search)) -or
            ($_.RiskLevel  -and $_.RiskLevel.ToLower().Contains($search))  -or
            ($_.SigStatus  -and $_.SigStatus.ToLower().Contains($search))  -or
            ($_.Category   -and $_.Category.ToLower().Contains($search))   -or
            ($_.Details    -and $_.Details['FullMessage'] -and
             $_.Details['FullMessage'].ToLower().Contains($search))
        }
    }

    $script:filteredEvents = @($pool)
    $LV.ItemsSource        = $script:filteredEvents
    $showTxt.Text          = "Showing: $($script:filteredEvents.Count)"
}

# ============================================================
#  LOAD EVENTS
# ============================================================
function Load-Events {
    $statusTxt.Text  = "Loading events..."
    $window.Cursor   = [System.Windows.Input.Cursors]::Wait
    $LV.ItemsSource  = $null

    try {
        $raw        = [System.Collections.ArrayList]::new()
        $riskyCount = 0
        $defCount   = 0
        $psCount    = 0
        $devCount   = 0
        $critCount  = 0

        # ---- App Crashes ----
        $statusTxt.Text = "Loading Application crash events (1000/1002)..."
        try {
            $evts = Get-WinEvent -FilterHashtable @{LogName='Application';ID=1000,1002} -MaxEvents 10000 -ErrorAction Stop
            foreach ($ev in $evts) {
                $d = Parse-AppCrash -msg $ev.Message -ev $ev
                $null = $raw.Add((New-Item-Row -d $d))
                if ($d['RiskLevel'] -in @('Medium','High','Danger','CRITICAL','DELETED','TAMPERED')) { $riskyCount++ }
                if ($d['RiskLevel'] -eq 'CRITICAL') { $critCount++ }
            }
        } catch { }

        # ---- Defender ----
        $statusTxt.Text = "Loading Defender events (1116/1117)..."
        try {
            $evts = Get-WinEvent -FilterHashtable @{
                LogName='Microsoft-Windows-Windows Defender/Operational';ID=1116,1117
            } -MaxEvents 5000 -ErrorAction Stop
            foreach ($ev in $evts) {
                $d = Parse-Defender -msg $ev.Message -ev $ev
                $null = $raw.Add((New-Item-Row -d $d))
                $defCount++
                if ($d['RiskLevel'] -eq 'CRITICAL') { $critCount++ }
            }
        } catch { }

        # ---- System 7034 ----
        $statusTxt.Text = "Loading System service crash events (7034)..."
        try {
            $evts = Get-WinEvent -FilterHashtable @{LogName='System';ID=7034} -MaxEvents 5000 -ErrorAction Stop
            foreach ($ev in $evts) {
                $d = Parse-SystemEvent -msg $ev.Message -ev $ev
                $null = $raw.Add((New-Item-Row -d $d))
            }
        } catch { }

        # ---- PS 4104 ----
        $statusTxt.Text = "Loading PowerShell ScriptBlock events (4104)..."
        try {
            $evts = Get-WinEvent -FilterHashtable @{
                LogName='Microsoft-Windows-PowerShell/Operational';ID=4104
            } -MaxEvents 20000 -ErrorAction Stop
            foreach ($ev in $evts) {
                $d = Parse-PSEvent -msg $ev.Message -ev $ev
                if ($d['RiskLevel'] -ne 'Info') {
                    $null = $raw.Add((New-Item-Row -d $d))
                    $psCount++
                    if ($d['RiskLevel'] -in @('Medium','High','CRITICAL')) { $riskyCount++ }
                    if ($d['RiskLevel'] -eq 'CRITICAL') { $critCount++ }
                }
            }
        } catch { }

        # ---- PS Legacy 400/403/800 ----
        $statusTxt.Text = "Loading legacy PowerShell events (400/403/800)..."
        try {
            $evts = Get-WinEvent -FilterHashtable @{
                LogName='Windows PowerShell';ID=400,403,800
            } -MaxEvents 10000 -ErrorAction Stop
            foreach ($ev in $evts) {
                $d = Parse-PSEvent -msg $ev.Message -ev $ev
                if ($d['RiskLevel'] -ne 'Info') {
                    $null = $raw.Add((New-Item-Row -d $d))
                    $psCount++
                    if ($d['RiskLevel'] -in @('Medium','High','CRITICAL')) { $riskyCount++ }
                    if ($d['RiskLevel'] -eq 'CRITICAL') { $critCount++ }
                }
            }
        } catch { }

        # ---- Kernel-PnP ----
        $statusTxt.Text = "Loading Kernel-PnP device events..."
        try {
            $evts = Get-WinEvent -FilterHashtable @{
                LogName='Microsoft-Windows-Kernel-PnP/Configuration';ID=400,410,2003,2100,2101,2102
            } -MaxEvents 3000 -ErrorAction Stop
            foreach ($ev in $evts) {
                $d = Parse-DeviceEvent -msg $ev.Message -ev $ev -src 'Kernel-PnP'
                $null = $raw.Add((New-Item-Row -d $d))
                $devCount++
            }
        } catch { }

        # ---- Hyper-V ----
        $statusTxt.Text = "Loading Hyper-V events..."
        try {
            $evts = Get-WinEvent -FilterHashtable @{
                LogName='Microsoft-Windows-Hyper-V-Hypervisor/Operational'
            } -MaxEvents 1000 -ErrorAction Stop
            foreach ($ev in $evts) {
                $d = Parse-DeviceEvent -msg $ev.Message -ev $ev -src 'Hyper-V'
                $null = $raw.Add((New-Item-Row -d $d))
                $devCount++
            }
        } catch { }

        # ---- Deduplicate ----
        $statusTxt.Text = "Deduplicating..."
        $grouped = $raw | Group-Object -Property AppName, AppPath, Id, Category
        $deduped = [System.Collections.ArrayList]::new()
        foreach ($g in $grouped) {
            $first = $g.Group | Sort-Object TimeCreated -Descending | Select-Object -First 1
            $null = $deduped.Add([PSCustomObject]@{
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
            })
        }

        $script:baseEvents = @($deduped | Sort-Object TimeCreated -Descending)

        # Stats
        $totalTxt.Text = "Total: $($raw.Count)"
        $riskyTxt.Text = "Risky: $riskyCount"
        $defTxt.Text   = "Defender: $defCount"
        $psTxt.Text    = "PowerShell: $psCount"
        $devTxt.Text   = "Devices: $devCount"
        $critTxt.Text  = "CRITICAL: $critCount"

        Apply-Filter
        $statusTxt.Text = "Loaded $($raw.Count) raw  |  $($script:baseEvents.Count) unique  |  $riskyCount risky  |  $critCount CRITICAL  |  $psCount PS flags  |  $defCount Defender  |  $devCount devices"
    }
    catch {
        $statusTxt.Text = "Error during load: $($_.Exception.Message)"
    }
    finally {
        $window.Cursor = [System.Windows.Input.Cursors]::Arrow
    }
}

# ============================================================
#  EXPORT
# ============================================================
function Export-Results {
    if (-not $script:filteredEvents -or $script:filteredEvents.Count -eq 0) {
        $statusTxt.Text = "No events to export"; return
    }
    $ts   = Get-Date -Format "yyyyMMdd_HHmmss"
    $file = "SuspiciousEvents_$($script:currentTab)_$ts.csv"
    $script:filteredEvents | ForEach-Object {
        [PSCustomObject]@{
            TimeCreated = $_.TimeCreated
            EventID     = $_.Id
            Category    = $_.Category
            Application = $_.AppName
            Path        = $_.AppPath
            Module      = $_.ModuleName
            Signature   = $_.SigStatus
            RiskLevel   = $_.RiskLevel
            FlagCount   = if ($_.Details) { $_.Details['FlagCount'] } else { 0 }
            Severity    = if ($_.Details) { $_.Details['Severity'] } else { '' }
            Flags       = if ($_.Details) { $_.Details['RiskMatches'] } else { '' }
            EventCount  = $_.EventCount
            FullMessage = if ($_.Details) { $_.Details['FullMessage'] } else { '' }
        }
    } | Export-Csv -Path $file -NoTypeInformation
    $statusTxt.Text = "Exported $($script:filteredEvents.Count) events to $file"
}

# ============================================================
#  DETAIL WINDOW  — fixed: no inline 'if' in Add-Member calls
# ============================================================
function Show-DetailWindow {
    param($item)

    $d = $item.Details

    # --- Safe value extraction (NO inline if — fixes the error) ---
    $safeTC   = $item.TimeCreated
    $safeId   = $item.Id
    $safeCat  = $item.Category
    $safeApp  = $item.AppName
    $safePath = $item.AppPath
    $safeMod  = $item.ModuleName
    $safeModP = $item.ModulePath
    $safeRL   = $item.RiskLevel
    $safeRC   = $item.RiskColor
    $safeSig  = $item.SigStatus
    $safeSigC = $item.SigColor
    $safeCt   = $item.EventCount

    $safeExc  = ''; $safePID = ''; $safeRep = ''
    $safeWT   = ''; $safeRM  = ''; $safeTN  = ''
    $safeAct  = ''; $safeFl  = 0;  $safeSev = ''
    $safeSigD = ''; $safeSevD= ''; $safeProc= ''
    $safeDetT = ''; $safeDetU= ''; $safeDetP= ''
    $safeTCat = ''; $safeTSev= ''

    if ($d) {
        if ($d['ExceptionCode'])  { $safeExc  = $d['ExceptionCode'] }
        if ($d['ProcessId'])      { $safePID  = $d['ProcessId'] }
        if ($d['ReportId'])       { $safeRep  = $d['ReportId'] }
        if ($d['WindowTitle'])    { $safeWT   = $d['WindowTitle'] }
        if ($d['RiskMatches'])    { $safeRM   = $d['RiskMatches'] }
        if ($d['ThreatName'])     { $safeTN   = $d['ThreatName'] }
        if ($d['Action'])         { $safeAct  = $d['Action'] }
        if ($d['FlagCount'])      { $safeFl   = $d['FlagCount'] }
        if ($d['Severity'])       { $safeSev  = $d['Severity'] }
        if ($d['SigDetail'])      { $safeSigD = $d['SigDetail'] }
        if ($d['ThreatSeverity']) { $safeTSev = $d['ThreatSeverity'] }
        if ($d['ThreatCategory']) { $safeTCat = $d['ThreatCategory'] }
        if ($d['ProcessName'])    { $safeProc = $d['ProcessName'] }
        if ($d['DetectionTime'])  { $safeDetT = $d['DetectionTime'] }
        if ($d['DetectedUser'])   { $safeDetU = $d['DetectedUser'] }
        if ($d['DetectedPath'])   { $safeDetP = $d['DetectedPath'] }
    }

    $safeMsg = if ($d -and $d['FullMessage']) { $d['FullMessage'] } else { '' }

    $detailXaml = @'
<Window xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
        xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
        Title="Event Details" Width="920" Height="720"
        WindowStartupLocation="CenterOwner" Background="#FF1A1A1C"
        WindowStyle="SingleBorderWindow" ResizeMode="CanResize">
    <Grid>
        <Grid.RowDefinitions>
            <RowDefinition Height="*"/>
            <RowDefinition Height="Auto"/>
        </Grid.RowDefinitions>
        <ScrollViewer Grid.Row="0" VerticalScrollBarVisibility="Auto" Background="#FF1A1A1C">
            <StackPanel Margin="16">
                <TextBlock Text="Event Details" FontWeight="Bold" FontSize="15" Foreground="#FFE8E8E8" Margin="0,0,0,12"/>
                <Border Background="#FF252528" CornerRadius="6" Padding="14" Margin="0,0,0,12"
                        BorderBrush="#FF3A3A3C" BorderThickness="1">
                    <Grid>
                        <Grid.ColumnDefinitions>
                            <ColumnDefinition Width="175"/>
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
                            <RowDefinition Height="Auto"/><RowDefinition Height="Auto"/>
                            <RowDefinition Height="Auto"/><RowDefinition Height="Auto"/>
                            <RowDefinition Height="Auto"/>
                        </Grid.RowDefinitions>
                        <!-- Row 0 -->
                        <TextBlock Grid.Row="0" Grid.Column="0" Text="Time:" FontWeight="SemiBold" FontSize="11" Foreground="#FF9CDCFE" Margin="0,0,10,5"/>
                        <TextBlock Grid.Row="0" Grid.Column="1" x:Name="ValTime" FontSize="11" Foreground="#FFE0E0E0" TextWrapping="Wrap" FontFamily="Consolas" Margin="0,0,0,5"/>
                        <!-- Row 1 -->
                        <TextBlock Grid.Row="1" Grid.Column="0" Text="Event ID:" FontWeight="SemiBold" FontSize="11" Foreground="#FF9CDCFE" Margin="0,0,10,5"/>
                        <TextBlock Grid.Row="1" Grid.Column="1" x:Name="ValId" FontSize="11" Foreground="#FFE0E0E0" Margin="0,0,0,5"/>
                        <!-- Row 2 -->
                        <TextBlock Grid.Row="2" Grid.Column="0" Text="Category:" FontWeight="SemiBold" FontSize="11" Foreground="#FF9CDCFE" Margin="0,0,10,5"/>
                        <TextBlock Grid.Row="2" Grid.Column="1" x:Name="ValCat" FontSize="11" Foreground="#FFE0E0E0" Margin="0,0,0,5"/>
                        <!-- Row 3 -->
                        <TextBlock Grid.Row="3" Grid.Column="0" Text="Application:" FontWeight="SemiBold" FontSize="11" Foreground="#FF9CDCFE" Margin="0,0,10,5"/>
                        <TextBlock Grid.Row="3" Grid.Column="1" x:Name="ValApp" FontSize="11" Foreground="#FFE0E0E0" TextWrapping="Wrap" Margin="0,0,0,5"/>
                        <!-- Row 4 -->
                        <TextBlock Grid.Row="4" Grid.Column="0" Text="Path:" FontWeight="SemiBold" FontSize="11" Foreground="#FF9CDCFE" Margin="0,0,10,5"/>
                        <TextBlock Grid.Row="4" Grid.Column="1" x:Name="ValPath" FontSize="11" Foreground="#FFE0E0E0" TextWrapping="Wrap" FontFamily="Consolas" Margin="0,0,0,5"/>
                        <!-- Row 5 -->
                        <TextBlock Grid.Row="5" Grid.Column="0" Text="Module:" FontWeight="SemiBold" FontSize="11" Foreground="#FF9CDCFE" Margin="0,0,10,5"/>
                        <TextBlock Grid.Row="5" Grid.Column="1" x:Name="ValMod" FontSize="11" Foreground="#FFE0E0E0" TextWrapping="Wrap" Margin="0,0,0,5"/>
                        <!-- Row 6 -->
                        <TextBlock Grid.Row="6" Grid.Column="0" Text="Module Path:" FontWeight="SemiBold" FontSize="11" Foreground="#FF9CDCFE" Margin="0,0,10,5"/>
                        <TextBlock Grid.Row="6" Grid.Column="1" x:Name="ValModP" FontSize="11" Foreground="#FFE0E0E0" TextWrapping="Wrap" FontFamily="Consolas" Margin="0,0,0,5"/>
                        <!-- Row 7 -->
                        <TextBlock Grid.Row="7" Grid.Column="0" Text="Exception Code:" FontWeight="SemiBold" FontSize="11" Foreground="#FF9CDCFE" Margin="0,0,10,5"/>
                        <TextBlock Grid.Row="7" Grid.Column="1" x:Name="ValExc" FontSize="11" Foreground="#FFE0E0E0" FontFamily="Consolas" Margin="0,0,0,5"/>
                        <!-- Row 8 -->
                        <TextBlock Grid.Row="8" Grid.Column="0" Text="Process ID:" FontWeight="SemiBold" FontSize="11" Foreground="#FF9CDCFE" Margin="0,0,10,5"/>
                        <TextBlock Grid.Row="8" Grid.Column="1" x:Name="ValPID" FontSize="11" Foreground="#FFE0E0E0" Margin="0,0,0,5"/>
                        <!-- Row 9 -->
                        <TextBlock Grid.Row="9" Grid.Column="0" Text="Report ID:" FontWeight="SemiBold" FontSize="11" Foreground="#FF9CDCFE" Margin="0,0,10,5"/>
                        <TextBlock Grid.Row="9" Grid.Column="1" x:Name="ValRep" FontSize="11" Foreground="#FFE0E0E0" TextWrapping="Wrap" Margin="0,0,0,5"/>
                        <!-- Row 10 — Defender fields -->
                        <TextBlock Grid.Row="10" Grid.Column="0" Text="Threat Name:" FontWeight="SemiBold" FontSize="11" Foreground="#FF9CDCFE" Margin="0,0,10,5"/>
                        <TextBlock Grid.Row="10" Grid.Column="1" x:Name="ValTN" FontSize="11" Foreground="#FFFFA07A" TextWrapping="Wrap" Margin="0,0,0,5"/>
                        <!-- Row 11 -->
                        <TextBlock Grid.Row="11" Grid.Column="0" Text="Threat Severity:" FontWeight="SemiBold" FontSize="11" Foreground="#FF9CDCFE" Margin="0,0,10,5"/>
                        <TextBlock Grid.Row="11" Grid.Column="1" x:Name="ValTSev" FontSize="11" Foreground="#FFFFA07A" Margin="0,0,0,5"/>
                        <!-- Row 12 -->
                        <TextBlock Grid.Row="12" Grid.Column="0" Text="Threat Category:" FontWeight="SemiBold" FontSize="11" Foreground="#FF9CDCFE" Margin="0,0,10,5"/>
                        <TextBlock Grid.Row="12" Grid.Column="1" x:Name="ValTCat" FontSize="11" Foreground="#FFE0E0E0" Margin="0,0,0,5"/>
                        <!-- Row 13 -->
                        <TextBlock Grid.Row="13" Grid.Column="0" Text="Detected File:" FontWeight="SemiBold" FontSize="11" Foreground="#FF9CDCFE" Margin="0,0,10,5"/>
                        <TextBlock Grid.Row="13" Grid.Column="1" x:Name="ValDetP" FontSize="11" Foreground="#FFE0E0E0" TextWrapping="Wrap" FontFamily="Consolas" Margin="0,0,0,5"/>
                        <!-- Row 14 -->
                        <TextBlock Grid.Row="14" Grid.Column="0" Text="Action Taken:" FontWeight="SemiBold" FontSize="11" Foreground="#FF9CDCFE" Margin="0,0,10,5"/>
                        <TextBlock Grid.Row="14" Grid.Column="1" x:Name="ValAct" FontSize="11" Foreground="#FFE0E0E0" TextWrapping="Wrap" Margin="0,0,0,5"/>
                        <!-- Row 15 — PS fields -->
                        <TextBlock Grid.Row="15" Grid.Column="0" Text="PS Flags:" FontWeight="SemiBold" FontSize="11" Foreground="#FF9CDCFE" Margin="0,0,10,5"/>
                        <TextBlock Grid.Row="15" Grid.Column="1" x:Name="ValRM" FontSize="11" Foreground="#FFFFD700" TextWrapping="Wrap" Margin="0,0,0,5"/>
                        <!-- Row 16 -->
                        <TextBlock Grid.Row="16" Grid.Column="0" Text="Flag Count:" FontWeight="SemiBold" FontSize="11" Foreground="#FF9CDCFE" Margin="0,0,10,5"/>
                        <TextBlock Grid.Row="16" Grid.Column="1" x:Name="ValFl" FontSize="11" Foreground="#FFFFA07A" Margin="0,0,0,5"/>
                        <!-- Row 17 — Signature -->
                        <TextBlock Grid.Row="17" Grid.Column="0" Text="Signature:" FontWeight="SemiBold" FontSize="11" Foreground="#FF9CDCFE" Margin="0,0,10,5"/>
                        <StackPanel Grid.Row="17" Grid.Column="1" Orientation="Horizontal" Margin="0,0,0,5">
                            <Border x:Name="SigBorder" CornerRadius="3" Padding="6,2" HorizontalAlignment="Left">
                                <TextBlock x:Name="ValSig" Foreground="White" FontSize="10" FontWeight="Bold"/>
                            </Border>
                        </StackPanel>
                        <!-- Row 18 — Sig detail -->
                        <TextBlock Grid.Row="18" Grid.Column="0" Text="Sig Detail:" FontWeight="SemiBold" FontSize="11" Foreground="#FF9CDCFE" Margin="0,0,10,5"/>
                        <TextBlock Grid.Row="18" Grid.Column="1" x:Name="ValSigD" FontSize="10" Foreground="#FF888888" TextWrapping="Wrap" FontFamily="Consolas" Margin="0,0,0,5"/>
                        <!-- Row 19 — Risk -->
                        <TextBlock Grid.Row="19" Grid.Column="0" Text="Risk Level:" FontWeight="SemiBold" FontSize="11" Foreground="#FF9CDCFE" Margin="0,0,10,5"/>
                        <StackPanel Grid.Row="19" Grid.Column="1" Orientation="Horizontal" Margin="0,0,0,5">
                            <Border x:Name="RiskBorder" CornerRadius="3" Padding="6,2" HorizontalAlignment="Left">
                                <TextBlock x:Name="ValRL" Foreground="White" FontSize="10" FontWeight="Bold"/>
                            </Border>
                            <TextBlock x:Name="ValCt" FontSize="11" Foreground="#FFFFA07A" FontWeight="Bold" VerticalAlignment="Center" Margin="10,0,0,0"/>
                        </StackPanel>
                        <!-- Row 20 -->
                    </Grid>
                </Border>
                <TextBlock Text="Full Event Message" FontWeight="Bold" FontSize="13" Foreground="#FFE8E8E8" Margin="0,4,0,8"/>
                <TextBox x:Name="MsgBox" IsReadOnly="True" TextWrapping="Wrap" Height="220"
                         Background="#FF141416" Foreground="#FFE0E0E0" BorderThickness="1"
                         BorderBrush="#FF3A3A3C" FontSize="10" Padding="10" FontFamily="Consolas"
                         VerticalScrollBarVisibility="Auto"/>
            </StackPanel>
        </ScrollViewer>
        <Border Grid.Row="1" Background="#FF252528" BorderBrush="#FF3A3A3C" BorderThickness="0,1,0,0" Padding="12,7">
            <TextBlock Text="Double-click row to open details  •  F5 to refresh" Foreground="#FF444444"
                       FontSize="10" HorizontalAlignment="Center"/>
        </Border>
    </Grid>
</Window>
'@

    try {
        $dr   = New-Object System.Xml.XmlNodeReader ([xml]$detailXaml)
        $dwin = [Windows.Markup.XamlReader]::Load($dr)
        $dwin.Owner = $window
        $dwin.WindowStartupLocation = [System.Windows.WindowStartupLocation]::CenterOwner

        # Set all values via FindName — zero inline conditionals
        $dwin.FindName("ValTime").Text = $safeTC
        $dwin.FindName("ValId").Text   = "$safeId"
        $dwin.FindName("ValCat").Text  = $safeCat
        $dwin.FindName("ValApp").Text  = $safeApp
        $dwin.FindName("ValPath").Text = $safePath
        $dwin.FindName("ValMod").Text  = $safeMod
        $dwin.FindName("ValModP").Text = $safeModP
        $dwin.FindName("ValExc").Text  = $safeExc
        $dwin.FindName("ValPID").Text  = $safePID
        $dwin.FindName("ValRep").Text  = $safeRep
        $dwin.FindName("ValTN").Text   = $safeTN
        $dwin.FindName("ValTSev").Text = $safeTSev
        $dwin.FindName("ValTCat").Text = $safeTCat
        $dwin.FindName("ValDetP").Text = $safeDetP
        $dwin.FindName("ValAct").Text  = $safeAct
        $dwin.FindName("ValRM").Text   = $safeRM
        $dwin.FindName("ValFl").Text   = "$safeFl flags  |  Severity: $safeSev"
        $dwin.FindName("ValSig").Text  = $safeSig
        $dwin.FindName("ValSigD").Text = $safeSigD
        $dwin.FindName("ValRL").Text   = $safeRL
        $dwin.FindName("ValCt").Text   = "x$safeCt occurrences"
        $dwin.FindName("MsgBox").Text  = $safeMsg

        $dwin.FindName("SigBorder").Background  = [Windows.Media.SolidColorBrush][Windows.Media.ColorConverter]::ConvertFromString($safeSigC)
        $dwin.FindName("RiskBorder").Background = [Windows.Media.SolidColorBrush][Windows.Media.ColorConverter]::ConvertFromString($safeRC)

        $dwin.ShowDialog() | Out-Null
    } catch {
        [System.Windows.MessageBox]::Show("Detail window error: $($_.Exception.Message)")
    }
}

# ============================================================
#  WIRE UP CONTROLS
# ============================================================
$refreshBtn.Add_Click({ Load-Events })
$exportBtn.Add_Click({ Export-Results })
$clearBtn.Add_Click({ $searchBox.Text = '' })
$searchBox.Add_TextChanged({ Apply-Filter })
$LV.Add_MouseDoubleClick({
    if ($LV.SelectedItem) { Show-DetailWindow -item $LV.SelectedItem }
})

# ============================================================
#  LAUNCH
# ============================================================
Load-Events
$window.ShowDialog() | Out-Null
