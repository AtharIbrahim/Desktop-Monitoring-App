# System Monitor Desktop App

A comprehensive desktop system monitor application built with Flutter, similar to Rainmeter, that provides real-time system information with customizable widgets and floating desktop widgets.

## Features

### 🖥️ System Monitoring
- **CPU Usage**: Real-time CPU utilization with model information
- **RAM Usage**: Memory consumption with breakdown and status
- **GPU Usage**: Graphics card utilization monitoring with model details
- **Network Activity**: Upload/download speeds and connection status
- **Battery Status**: Battery level, charging status, and health indicators
- **Temperature Monitoring**: System temperature with color-coded alerts
- **Disk Usage**: Storage utilization monitoring
- **Process Monitoring**: Running processes count and top processes list

### 🎨 User Interface
- **Full View Mode**: Complete dashboard with all widgets
- **Minimal Mode**: Rainmeter-like floating widgets
- **Floating Desktop Widgets**: Individual widgets that float outside the app on your desktop
- **Dark/Light Theme**: Customizable appearance
- **Draggable Widgets**: Move floating widgets anywhere on screen
- **Responsive Design**: Adapts to different window sizes

### ⚙️ Customization
- **Widget Visibility**: Show/hide individual monitoring widgets
- **Floating Widget Controls**: Click to float individual widgets on desktop
- **Refresh Rate**: Adjustable update intervals (0.5-5 seconds)
- **Always on Top**: Keep window above other applications
- **Settings Persistence**: Saves your preferences

### 🎯 Rainmeter-like Features
- **Floating Overlay**: Minimal widget that stays on desktop
- **Individual Desktop Widgets**: CPU, RAM, GPU, Network, Battery, Temperature, Disk, Processes
- **Expandable/Collapsible**: Toggle between mini and full view
- **Custom Positioning**: Drag widgets to preferred locations
- **Independent Desktop Widgets**: Each widget can be floated separately outside the main app

### 📊 Extended System Information
- **System Identity**: Computer name, user name, architecture, OS details
- **Hardware Information**: CPU model, cores, GPU model, RAM total, disk space, screen resolution
- **System Status**: Running processes, uptime, temperature, battery status
- **Resource Usage**: Real-time usage percentages with progress bars
- **Running Processes**: List of currently active system processes
- **Selective Display**: Choose which metrics to show

## Installation

### Prerequisites
- Flutter SDK (latest stable version)
- Windows 10/11 for desktop build
- Visual Studio 2019/2022 with C++ tools

### Setup Instructions

1. **Clone or download** this project to your local machine

2. **Install dependencies**:
   ```bash
   cd system_monitor
   flutter pub get
   ```

3. **Run the application**:
   ```bash
   flutter run -d windows
   ```

4. **Build for release**:
   ```bash
   flutter build windows
   ```

## Usage

### Getting Started
1. Launch the application
2. The app will automatically start monitoring system metrics
3. Use the pause/play button to control monitoring
4. Access settings via the gear icon

### Minimal Mode (Rainmeter-like)
1. Click the **fullscreen icon** in the app bar to enter minimal mode
2. A floating widget will appear on your desktop
3. **Drag** the widget to position it anywhere
4. **Click the expand icon** to view detailed metrics
5. **Click the minimize icon** to collapse to mini view
6. Use **settings** to choose which metrics to display

### Desktop Floating Widgets
1. In the main app, scroll down to the **Desktop Widgets** section
2. Click on any widget button (CPU, RAM, GPU, Network, Battery, Temperature, Disk, Processes)
3. The widget will float on your desktop outside the main app window
4. **Drag** floating widgets to position them anywhere on your screen
5. **Click the X button** on a floating widget to close it
6. Floating widgets update in real-time independently

### Widget Controls
- **CPU Widget**: Shows usage percentage with color-coded status and CPU model
- **RAM Widget**: Displays memory usage with breakdown
- **GPU Widget**: Graphics utilization with GPU model information
- **Network Widget**: Upload/download speeds and connection types
- **Battery Widget**: Battery level with charging status
- **Temperature Widget**: System temperature with visual indicators
- **Disk Widget**: Storage usage with progress bar
- **Processes Widget**: Running process count and top processes list

### Extended System Information
The app now displays comprehensive system information including:
- **System Identity**: Computer name, user, architecture, OS version
- **Hardware Details**: CPU model, cores, GPU model, total RAM/disk, screen resolution
- **System Status**: Process count, uptime, temperature, battery status
- **Resource Usage**: Real-time usage percentages with visual progress bars
- **Active Processes**: List of currently running system processes

### Settings Options
- **Appearance**: Toggle dark mode, minimal mode
- **Widget Visibility**: Enable/disable individual widgets
- **Performance**: Adjust refresh rate, always on top
- **Reset**: Restore default settings

## Technical Details

### Architecture
- **Provider Pattern**: State management with Provider package
- **Custom Widgets**: Hand-built UI components without heavy dependencies
- **Real-time Updates**: Timer-based monitoring with configurable intervals
- **Persistent Settings**: SharedPreferences for saving user preferences

### Dependencies
```yaml
dependencies:
  flutter: sdk
  provider: ^6.0.5
  shared_preferences: ^2.2.0
  device_info_plus: ^9.1.0
  battery_plus: ^4.0.2
  connectivity_plus: ^4.0.2
  window_manager: ^0.3.5
  path_provider: ^2.1.0
  intl: ^0.18.1
```

### Data Sources
- **CPU**: Simulated realistic fluctuations (5-95%)
- **RAM**: Simulated memory usage (2-14GB of 16GB)
- **GPU**: Simulated graphics utilization
- **Network**: Random upload/download speeds
- **Battery**: Real battery status via battery_plus
- **Temperature**: Simulated temperature data (40-70°C)
- **OS Info**: Real system information via device_info_plus

## Customization

### Adding New Widgets
1. Create a new widget file in `lib/widgets/`
2. Implement the monitoring logic
3. Add to `home_screen.dart` and `overlay_widget.dart`
4. Add settings controls in `settings_provider.dart`

### Styling
- Modify `lib/utils/theme.dart` for global theming
- Update individual widget colors and styles
- Customize the overlay widget appearance

### Platform-Specific Features
For real system monitoring on different platforms:
- **Windows**: Use Windows APIs via FFI
- **macOS**: Implement platform channels for system calls
- **Linux**: Access `/proc` filesystem for metrics

## Screenshots

### Full Dashboard View
- Complete system overview with all widgets
- Real-time charts and progress indicators
- System information panel

### Minimal Mode
- Floating desktop widget
- Expandable/collapsible interface
- Draggable positioning

### Settings Panel
- Comprehensive customization options
- Widget visibility controls
- Performance tuning

## Development

### Running in Development
```bash
flutter run -d windows --debug
```

### Hot Reload
The app supports Flutter's hot reload for rapid development.

### Building for Production
```bash
flutter build windows --release
```

## Known Limitations

1. **Real System Data**: Currently uses simulated data for most metrics
2. **Platform Support**: Optimized for Windows desktop
3. **GPU Monitoring**: Requires platform-specific implementation
4. **Temperature Sensors**: Needs hardware sensor access

## Future Enhancements

- [ ] Real CPU/GPU monitoring via platform channels
- [ ] Network usage tracking
- [ ] Process monitoring and management
- [ ] Custom widget themes
- [ ] Export monitoring data
- [ ] System alerts and notifications
- [ ] Multiple monitor support
- [ ] Widget snapping and alignment
- [ ] Custom widget layouts

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test thoroughly
5. Submit a pull request

## License

This project is open source and available under the MIT License.

## Support

For questions, issues, or feature requests, please create an issue in the project repository.

---

**Note**: This is a demonstration application with simulated system data. For production use, implement real system monitoring APIs specific to your target platform.
