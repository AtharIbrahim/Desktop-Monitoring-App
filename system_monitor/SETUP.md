# Quick Setup Guide

## 🚀 Getting Started in 3 Steps

### Step 1: Prerequisites
Ensure you have Flutter installed on your system:
- Download Flutter from [flutter.dev](https://flutter.dev)
- Add Flutter to your system PATH
- Install Visual Studio 2019/2022 with C++ tools for Windows

### Step 2: Install Dependencies
Open terminal/command prompt in the project directory and run:
```bash
flutter pub get
```

### Step 3: Run the Application
Launch the system monitor:
```bash
flutter run -d windows
```

## 🎯 Quick Start Features

### Immediate Usage
1. **Auto-Start Monitoring**: App begins monitoring immediately
2. **Full Dashboard**: See all system metrics at once
3. **Real-Time Updates**: Live data refresh every second

### Switch to Minimal Mode
1. Click the **expand/compress icon** in the top bar
2. Floating widget appears on desktop
3. Drag widget anywhere on screen
4. Click expand/minimize on widget to toggle size

### Customize Your Experience
1. Click **Settings (gear icon)** in the top bar
2. Toggle widgets on/off under "Widget Visibility"
3. Adjust refresh rate under "Performance"
4. Switch to dark mode under "Appearance"

## 🎮 Key Controls

| Action | Method |
|--------|--------|
| Pause/Resume Monitoring | Play/Pause button in top bar |
| Enter Minimal Mode | Fullscreen icon in top bar |
| Open Settings | Gear icon in top bar |
| Move Widget | Drag the floating widget |
| Expand Widget | Click expand icon on mini widget |
| Reset Settings | Settings → About → Reset Settings |

## 🔧 Quick Customization

### Show Only CPU and RAM
1. Go to Settings
2. Under "Widget Visibility":
   - Keep "CPU Monitor" ON
   - Keep "RAM Monitor" ON  
   - Turn OFF all others
3. Enable "Minimal Mode"

### Gaming Mode Setup
1. Enable "Always on Top"
2. Set refresh rate to 0.5 seconds
3. Show only CPU, GPU, and Temperature widgets
4. Use minimal mode for desktop overlay

### Battery Saver Mode
1. Set refresh rate to 5 seconds
2. Show only Battery and Temperature
3. Enable dark mode
4. Use minimal mode

## 🎨 Visual Themes

### Dark Theme
- Go to Settings → Appearance → Dark Mode: ON
- Modern dark interface with blue accents

### Light Theme (Default)
- Clean, professional light interface
- High contrast for better visibility

## 🚨 Troubleshooting

### App Won't Start
1. Ensure Flutter is installed: `flutter --version`
2. Run `flutter doctor` to check setup
3. Try `flutter clean` then `flutter pub get`

### No System Data
- App uses simulated data for demonstration
- Real hardware monitoring requires platform-specific implementation
- Battery data is real when available

### Performance Issues
1. Increase refresh rate to 2-5 seconds
2. Disable unused widgets
3. Close other resource-intensive applications

## 💡 Pro Tips

1. **Desktop Widget**: Use minimal mode to create a persistent desktop overlay
2. **Drag Positioning**: Position widget in corner for easy monitoring
3. **Quick Toggle**: Use expand/minimize to switch between views
4. **Settings Persist**: Your configuration is automatically saved
5. **Multiple Instances**: Run multiple widgets for different metric groups

## 🎯 Best Practices

### For Development
- Enable CPU and RAM monitoring
- Set 1-second refresh rate
- Use always on top feature

### For Gaming
- Monitor CPU, GPU, and Temperature
- Position widget in screen corner
- Use minimal mode to avoid distraction

### For General Use
- Enable all widgets for full overview
- Use 2-second refresh rate for balanced performance
- Switch between full and minimal modes as needed

That's it! You now have a fully functional system monitor with Rainmeter-like capabilities. Explore the settings to customize it to your preferences.
