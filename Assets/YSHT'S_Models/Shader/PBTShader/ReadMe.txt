##################################################################################################
ライセンス
##################################################################################################
MIT License

Copyright (c) 2019 yosohuta

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and 
associated documentation files (the "Software"), to deal in the Software without restriction, 
including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, 
and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, 
subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial 
portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, 
INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. 
IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, 
WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, 
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE. 


##################################################################################################
パラメータ説明
##################################################################################################
基本的にパラメータをあまり弄る必要が内容に設計してますが、
狙った質感が出なかった場合に任意で調整してください。

FakeLight
	シェーダーで定義したライト方向に従って影を生成します。
FakeLightAngle
	上記の疑似ライトの上下角度を設定します。
	
Albedo
	StandardのAlbedoに相当。色情報テクスチャを設定します。
Alpha Cutoff
	StandardのCutoutモードでのAlphaCutoffに相当。透過の際の閾値を設定します。
	
ToonRamp
	影の色及び影の質感を設定するRampテクスチャを設定します。

ShadowMask
	影のかかり具合を調整します。
	影をかけたくない部分(顔など)を黒く塗りつぶしたテクスチャを割り当てることで、
	その部分に影がかからなくなります。
	
MetallicMap
	StandardのMetallicに相当。
	金属か非金属の度合いを白黒で、
	表面の粗さを透明度で表現したメタルネステクスチャを割り当てます。
	
Metalness
	金属度合いを調整できます。
Roughness
	表面の粗さを調整できます。
SpecularPower
	光沢の強さを調整できます。
	
NormalMap
	StandardのNormalに相当。ノーマルマップ(法線マップ)を割り当てます。
Normal Level
	上記のノーマルマップの適用度を調整できます。
	
EmissionMap
	StandardのEmissionに相当。発光部分を指定できます。
Emissin Power
	上記のEmissionMapの発光強度を調整できます。
	
Outline Mask
	輪郭線の太さを白黒テクスチャで指定できます。
	
Outline Width
	輪郭線の太さを指定できます。
	
AddAlbedoColor
	Albedoテクスチャに色を加算できます。
	
EnvMatCap
BlurEnvMatCap
	金属部分で反射する環境光を再現するMatcapテクスチャです。
	表面の粗さ(Roughness：ラフネス)によって二つのテクスチャがミックスされて適用されます。
	
AddMatCap
	光沢を表現するために用いられる加算MatCapです。
	表面の粗さが低い程光沢が鋭くなります。

MultiplyMatCap
	乗算MatCapです。
MultiplyMatPower
	上記の乗算MatCapの適用度を調整できます。

##################################################################################################
質問や何かしら問題がありましたら、Twitter等にお問い合わせください

四拾弐(YOSOHUTA)
@yosohuta

