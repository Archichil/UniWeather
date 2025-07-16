# UniWeather

UniWeather is a modern, functional weather app built with Swift, inspired by Apple's clean and intuitive design principles. The app provides up-to-date weather information with a focus on simplicity, usability, and elegant visuals.


## Features
- 🌦️ **Real-time weather updates** for your location  
  *Includes air pollution, wind speed, humidity, and feels-like temperature*
- 🗺️ **Interactive map** with 15 weather characteristic layers
- 📅 **Hourly and weekly forecasts**
- 🤖 **AI Assistant** for personalized weather insights
- 📆 **Integration with system calendar** *(Holiday forecasts)*
- 🔎 **Search and save multiple cities**
- ⌚ **watchOS mini-app** for weather on your wrist _(Implemented, but not deployed)_
- 🧩 **Dynamic widgets** that auto-update with the latest info
- ✨ **Sleek, Apple-like user interface**
- 📱 **Responsive and easy-to-use design**

## Screenshots

<div align="center">

<table width="100%">
  <tr>
    <td align="center" width="25%"><b>Main Screen</b></td>
    <td align="center" width="25%"><b>Map</b></td>
    <td align="center" width="25%"><b>AI Assistant</b></td>
    <td align="center" width="25%"><b>Location Searcher</b></td>
  </tr>
  <tr>
    <td width="25%"><img src="https://github.com/user-attachments/assets/9f504b94-55f9-4cf7-ab6d-125b5493c940" alt="main_screen_feature" width="100%" /></td>
    <td width="25%"><img src="https://github.com/user-attachments/assets/d668c0a6-0235-40b6-85db-abf9c6ecb1aa" alt="map_feature" width="100%" /></td>
    <td width="25%"><img src="https://github.com/user-attachments/assets/af1efb6a-982f-4d63-b678-52a906fa171a" alt="ai_feature" width="100%" /></td>
    <td width="25%"><img src="https://github.com/user-attachments/assets/30de5ca9-b514-4737-88b2-b019187a081f" alt="saved_locations_feature" width="100%" /></td>
  </tr>
</table>

<br>

<table width="100%">
  <tr>
    <td align="center" width="33%"><b>Holiday Forecast</b></td>
    <td align="center" width="33%"><b>Widgets</b></td>
    <td align="center" width="33%"><b>Widgets</b></td>
  </tr>
  <tr>
    <td width="33%"><img src="https://github.com/user-attachments/assets/e7cda937-9378-44a6-8e62-c405dfb798b8" alt="holiday_forecast_feature" width="100%" /></td>
    <td width="33%"><img src="https://github.com/user-attachments/assets/640ba0ba-137c-45e5-ad0f-ae52a4dd71f6" alt="widgets_feature_1" width="100%" /></td>
    <td width="33%"><img src="https://github.com/user-attachments/assets/c02a9484-28c8-4d3c-87ef-0070dc99689e" alt="widgets_feature_2" width="100%" /></td>
  </tr>
</table>

</div>

## Getting Started

> :warning: Code in this repo may be far from production quality and is not expected to be easy and welcoming to newcomers.
>
> Continue on your own risk! Help & ideas are always welcome!

1. **Clone the repository:**
   ```bash
   git clone https://github.com/Archichil/UniWeather.git
   ```

2. **Open the project in Xcode.**

3. **Rename the files named Config_example.plist([`Config_example.plist (Main target)`](UniWeather/Config_Example.plist) [`Config_example.plist (Widgets)`](UniWeatherWidgets/Config_Example.plist))  to `Config.plist`.**

4. **Put your API keys in the `Config.plist`.**

5. **IMPORTANT! Choose your account to sign the app and add the app group!**

6. **Change the app group constant in the code [`UserDefaults+Shared.swift`](UniWeather/Domain/Extensions/UserDefaults+Shared.swift#L11) here.** 

7. **Build and run** on your simulator or device. (Simulator constraints some app functionality)

## Requirements

- iOS 17.0+
- Xcode 16+
- Swift 5.10

## Contributing

Contributions are welcome! Please open an issue or submit a pull request for any improvements or suggestions.

## License

This project is licensed under the Apache License 2.0. See the [LICENSE](LICENSE) file for details.

---

> Inspired by Apple's design, crafted for everyone.
