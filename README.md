# WordsTodo

<p align="center">
  <a href="https://apps.apple.com/jp/app/wordstodo/id1598603193">
    <img alt="Download on the App Store" title="App Store" src="http://i.imgur.com/0n2zqHD.png" width="140">
  </a>
</p>

## Overview

<pre>
<img src="https://raw.githubusercontent.com/wiki/Toshiyana/messageTodo/images/6.5inch.001.jpeg" width="220">&nbsp; <img src="https://raw.githubusercontent.com/wiki/Toshiyana/messageTodo/images/6.5inch.002.jpeg" width="220">&nbsp; <img src="https://raw.githubusercontent.com/wiki/Toshiyana/messageTodo/images/6.5inch.003.jpeg" width="220">&nbsp; 
</pre>

## Reason for Devlopment
コロナ禍でリモートとなったことで、人によってはモチベーションが低下してしまう事がわかっている（https://prtimes.jp/main/html/rd/p/000000008.000057624.html ）。
そこで、モチベーションを上げながらタスクをこなしていけるように、自身の好きな言葉・名言で応援してくれるタスク管理アプリを開発しました。

## Technologies
[GUI Architecture]
MVC

[Languages]
- Swift
- UIKit

[DataBase]
- RealmSwift: Save Items data and Messages data.
- UserDefaults: Save a theme color and a message arrangement.

[Libraries]
- RealmSwift: Use for a database.
- SwipeCellKit: Use for deleting a cell.
- CropViewController: Use for cropping a image after chosing it from album or camera.
- Google-Mobile-Ads-SDK: Use for admob.
- FirebaseAnalytics: Use for analytics.
- SwiftLint: Use for formatting codes.

## Screenshots

| TodoList | Add Todo | Set Reminder |
|:---:|:---:|:---:|
| <img src="https://raw.githubusercontent.com/wiki/Toshiyana/messageTodo/images/TodoListView.png" width=220 > | <img src="https://raw.githubusercontent.com/wiki/Toshiyana/messageTodo/images/SettingTodoView.png" width=220 > | <img src="https://raw.githubusercontent.com/wiki/Toshiyana/messageTodo/images/SettingReminderView.png" width=220 > |

| MessageList | Add Message | Setting | Select Color |
|:---:|:---:|:---:|:---:|
| <img src="https://raw.githubusercontent.com/wiki/Toshiyana/messageTodo/images/WordsListView.png" width=220 > | <img src="https://raw.githubusercontent.com/wiki/Toshiyana/messageTodo/images/SettingWordsView.png" width=220 > | <img src="https://raw.githubusercontent.com/wiki/Toshiyana/messageTodo/images/SettingView.png" width=220 > | <img src="https://raw.githubusercontent.com/wiki/Toshiyana/messageTodo/images/ThemeColorView.png" width=220 > |
