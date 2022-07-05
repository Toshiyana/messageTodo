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
そこで、モチベーションを上げながらタスクをこなしていけるように、自身の好きな言葉・名言で応援してくれるタスク管理アプリを開発した。

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

## 難しかった点
* Delegateパターンを用いた、クラスから他のクラスに処理を任せる実装の理解に苦労した。
* タスクのリマインダーを設定するためのローカル通知機能の実装に苦労した。

自分で調べてもわからない時は、iOSアプリ開発のコミュニティの現役エンジニアに質問して解決した。

## 工夫した点
### 機能面
* 新規性。好きな言葉を添えてタスクを通知するという今までにないアプリ。
* 誰でも簡単に操作できるような分かりやすいUI。
* 24種類のテーマカラーを選択可能。
* タスクのリマインダー機能。時間間隔と日時で設定可能。
* ユーザからの不具合の声に対応できるよう、アプリ内からGoogleフォームで問い合わせできるようにした。
* 検索機能。
* 並び替え機能。

### 技術面
* ViewControllerの肥大化を軽減するために、MVCアーキテクチャを採用した。
* データをローカルに保存するためにRealmを用いた。
* 操作性向上のため、SwipeCellKitやCropViewControllerなどのライブラリを用いた。
* コードを整えるために、SwiftLintを導入した。
* パフォーマンス向上のため、finalやprivate修飾子を適宜用いた。
* 収益化のために、Admobを導入した。

### GitHubでのコード管理
* 管理しやすくするために、main, develop, feature/…などとブランチを分けて機能ごとにブランチを作って開発を進めた。
