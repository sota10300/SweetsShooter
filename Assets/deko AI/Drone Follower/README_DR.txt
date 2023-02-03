◆◆ Drone Follower  ドローンフォロワー ◆◆

The drone of the 'Anubis;Error' short film.
In this world you can watch both the drone and the film:
https://vrch.at/cdgx6mem


短編映画「Anubis;Error」のドローン。
この世界では、ドローンとフィルムの両方を見ることができるのです。
https://vrch.at/cdgx6mem

A simple, one-step, standalone crewmate follower based on the 'Among Us Follower'.
● Drone Follower no Grab

It also includes a version requiring a slightly more complex setup:
● Drone Follower with Grab

● System requirement: SDK3 Avatars, Unity 2019.4.31f1

Among Us Follower」をベースにした、シンプルでワンステップのスタンドアローンのクルーメイトフォロワーです。
ドローンフォロワーのグラブなし

少し複雑な設定を必要とするバージョンも含まれています。
ドローンフォロワー（Grabあり

システム要件 SDK3 Avatars、Unity 2019.4.31f1。

◆◆ License ◆◆
The model, textures and animation are the property of the author.
The original model, textures and animations are not for resale.
The Drone model cannot be changed or upgraded.
Only the changed textures and animations can be resold.

◆◆ Drone Follower no Grab Installation ◆◆ 
	● Drop the "Drone Follower no Grab" prefab on your Avatar in the hierarchy.
	♥ Done

◆◆ Drone Follower with Grab Installation ◆◆
	● Drop the "Drone Follower with Grab" prefab on your Avatar in the hierarchy.
	● If you don't have an FX layered, use the Grab FX_DR layerer. Drag it into the FX slot of your avatar.


If you have your own FX layered
	● You will need to make the following changes to your Avatar's FX Animator:
		!!! Open your own Avatar's FX layer!!! 
		→ In the 'Parameter' tab, add a Bool, name it Follower_IsGrabbed
		→ In the 'Layer' tab, create a new layer. Name: Grab, Weight value:1
		→ Copy the Nodes from the 'Grab FX_DR' layer in the 'DroneFollower' folder 
		and paste them into your own 'FX layers' Grab. Make sure that the order
		of the nodes is not reversed when copying! This is important!
		→ Be sure to check that the 'Is Grabbed_DR' 'Is Not Grabbed_DR' in 'Animation'
		paths are correct. If it is yellow, copy the name of the prefab
		and correct the name in the path.
		This tutorial video contains the same settings, so you can set it up based on that:
		https://youtu.be/gCxk7B6fGpQ
		(2:08 Doggy Follower with Grab)
		♥ Done

◆◆ Customization ◆◆
	● The armature of the follower can be scaled.
	● Increasing the weight of the "Follow Target" (default weight 0.008) under 
	the "Follower Constraint" will make it move faster.
	● Moving the "Follow Target" will shift the rest position of the crewmember it will follow.
	● Moving "Look At Target" within the follower target changes where the crewmate 
	will look in their rest position.
	● Changing the value of the last keyframe of the "SFX On" animation will determine how loud 
	the walk sound will be. Currently set to very quiet: 0.3

◆◆ Download ◆◆
You can get the latest version of Drone Follower at https://dekoai.booth.pm/.

◆◆ Portfolio ◆◆
https://aideko.hu/

◆◆ Support ◆◆
If you have any problems or need help with the package, drop me a line.


ライセンス
モデル、テクスチャ、アニメーションは作者の所有物です。
オリジナルモデル、テクスチャ、アニメーションの再販はできません。
ドローンモデルの変更、アップグレードはできません。
変更したテクスチャとアニメーションのみ再販可能です。

ドローンフォロワーのグラブ設置
Drone Follower no Grab」プレハブをヒエラルキー上のアバターにドロップします。
完了

グラブ付きドローンフォロワーの設置
Drone Follower with Grab」プレハブをヒエラルキー上の自分のアバターにドロップします。
FXをレイヤー化していない場合は、Grab FX_DRレイヤーを使用します。アバターのFXスロットにドラッグしてください。

独自のFXをレイヤー化している場合。
	アバターのFXアニメーターに、以下の変更を加える必要があります。
		!!! 自分のアバターの FX レイヤーを開いてください!!! 
		→ パラメータ'タブで、Boolを追加し、Follower_IsGrabbedと名付けます。
		→ レイヤー'タブで、新しいレイヤーを作成します。名前を グラブ、ウェイト値:1
		→ DroneFollower'フォルダ内の'Grab FX_DR'レイヤーからノードをコピーし、自分の'FX FX'レイヤーに貼り付けます。 
		をコピーし、自分の'FXレイヤー'のGrabに貼り付けます。ノードの順番が逆になっていないことを確認する
		ノードの順序が逆になっていないことを確認してください。これは重要です!
		→ アニメーション'の'Is Grabbed_DR' 'Is Not Grabbed_DR'のパスが正しいことを確認してください。
		のパスが正しいかどうか。黄色い場合は、プレハブの名前をコピーして
		をコピーし、パスの名前を修正してください。
		こちらのチュートリアル動画にも同じ設定がありますので、それを元に設定してください。
		https://youtu.be/gCxk7B6fGpQ
		(2:08 Doggy Follower with Grab)
		完了

カスタマイズ
	フォロワーのアーマチュアは、スケーリングすることができます。
	Follow Target" (デフォルトのウェイト0.008) のウェイトを増やすと、より速く動きます。
	Follower Constraint "の "Follow Target "のウェイトを増やすと、より高速に動きます。
	Follow Target "を移動させると、追従するクルーの静止位置が移動します。
	フォロワーターゲット内の "Look At Target "を移動させると、そのクルーが静止している時の視線が変化します。
	を移動させると、そのクルーが休んでいる位置を見ることができます。
	SFX On "アニメーションの最後のキーフレームの値を変更することで、歩行音の大きさを決定します。
	歩いている時の音の大きさを設定します。現在は 0.3 の非常に小さな音に設定されています。

ダウンロード
Drone Follower の最新版は、https://dekoai.booth.pm/ から入手できます。

ポートフォリオ
https://aideko.hu/

サポート
パッケージの不具合やヘルプが必要な場合は、LINEでご連絡ください。