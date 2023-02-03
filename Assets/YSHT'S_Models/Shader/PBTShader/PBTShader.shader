// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "YSHT Shaders/PBTShader"
{
	Properties
	{
		[Toggle]_FakeLight("FakeLight", Float) = 0
		_FakeLightAngle("FakeLightAngle", Range( 0 , 180)) = 45
		_MainTex("Albedo", 2D) = "white" {}
		_AlphaCutoff("Alpha Cutoff", Range( 0 , 1)) = 0.5
		_ToonRamp("Toon Ramp", 2D) = "white" {}
		_ShadowMask("ShadowMask", 2D) = "white" {}
		_MetallicGlossMap("MetallicMap", 2D) = "black" {}
		_Metalness("Metalness", Range( -1 , 1)) = 0
		_Roughness("Roughness", Range( -1 , 1)) = 0
		_SpecularPower("SpecularPower", Range( -1 , 1)) = 0
		[Normal]_BumpMap("NormalMap", 2D) = "bump" {}
		_NormalLevel("Normal Level", Range( 0 , 1)) = 1
		_EmissionMap("EmissionMap", 2D) = "white" {}
		_EmissionPower("EmissionPower", Float) = 0
		_AddAlbedoColor("AddAlbedoColor", Color) = (0,0,0,0)
		[NoScaleOffset]_EnvMatCap("EnvMatCap", 2D) = "black" {}
		[NoScaleOffset]_BlurEnvMatCap("BlurEnvMatCap", 2D) = "black" {}
		[NoScaleOffset]_SpecularMatCap("AddMatCap", 2D) = "black" {}
		[NoScaleOffset]_ShadowMatCap("MultiplyMatCap", 2D) = "white" {}
		_ShadowMatPower("MultiplyMatPower", Range( 0 , 1)) = 0.5
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "TransparentCutout"  "Queue" = "Geometry+0" "IgnoreProjector" = "True" }
		Cull Off
		ZWrite On
		CGINCLUDE
		#include "UnityPBSLighting.cginc"
		#include "UnityStandardUtils.cginc"
		#include "UnityCG.cginc"
		#include "UnityShaderVariables.cginc"
		#include "Lighting.cginc"
		#pragma target 4.6
		#ifdef UNITY_PASS_SHADOWCASTER
			#undef INTERNAL_DATA
			#undef WorldReflectionVector
			#undef WorldNormalVector
			#define INTERNAL_DATA half3 internalSurfaceTtoW0; half3 internalSurfaceTtoW1; half3 internalSurfaceTtoW2;
			#define WorldReflectionVector(data,normal) reflect (data.worldRefl, half3(dot(data.internalSurfaceTtoW0,normal), dot(data.internalSurfaceTtoW1,normal), dot(data.internalSurfaceTtoW2,normal)))
			#define WorldNormalVector(data,normal) half3(dot(data.internalSurfaceTtoW0,normal), dot(data.internalSurfaceTtoW1,normal), dot(data.internalSurfaceTtoW2,normal))
		#endif
		struct Input
		{
			float2 uv_texcoord;
			float3 worldNormal;
			INTERNAL_DATA
			float3 worldPos;
		};

		struct SurfaceOutputCustomLightingCustom
		{
			half3 Albedo;
			half3 Normal;
			half3 Emission;
			half Metallic;
			half Smoothness;
			half Occlusion;
			half Alpha;
			Input SurfInput;
			UnityGIInput GIData;
		};

		uniform sampler2D _MainTex;
		uniform float4 _MainTex_ST;
		uniform float4 _AddAlbedoColor;
		uniform sampler2D _ToonRamp;
		uniform float _FakeLight;
		uniform float _NormalLevel;
		uniform sampler2D _BumpMap;
		uniform float4 _BumpMap_ST;
		uniform float _FakeLightAngle;
		uniform sampler2D _ShadowMask;
		uniform float4 _ShadowMask_ST;
		uniform sampler2D _BlurEnvMatCap;
		uniform sampler2D _EnvMatCap;
		uniform sampler2D _MetallicGlossMap;
		uniform float4 _MetallicGlossMap_ST;
		uniform float _Roughness;
		uniform float _Metalness;
		uniform sampler2D _SpecularMatCap;
		uniform float _SpecularPower;
		uniform sampler2D _ShadowMatCap;
		uniform float _ShadowMatPower;
		uniform sampler2D _EmissionMap;
		uniform float4 _EmissionMap_ST;
		uniform float _EmissionPower;
		uniform float _AlphaCutoff;


		float3 RGBToHSV(float3 c)
		{
			float4 K = float4(0.0, -1.0 / 3.0, 2.0 / 3.0, -1.0);
			float4 p = lerp( float4( c.bg, K.wz ), float4( c.gb, K.xy ), step( c.b, c.g ) );
			float4 q = lerp( float4( p.xyw, c.r ), float4( c.r, p.yzx ), step( p.x, c.r ) );
			float d = q.x - min( q.w, q.y );
			float e = 1.0e-10;
			return float3( abs(q.z + (q.w - q.y) / (6.0 * d + e)), d / (q.x + e), q.x);
		}

		float3 HSVToRGB( float3 c )
		{
			float4 K = float4( 1.0, 2.0 / 3.0, 1.0 / 3.0, 3.0 );
			float3 p = abs( frac( c.xxx + K.xyz ) * 6.0 - K.www );
			return c.z * lerp( K.xxx, saturate( p - K.xxx ), c.y );
		}


		inline half4 LightingStandardCustomLighting( inout SurfaceOutputCustomLightingCustom s, half3 viewDir, UnityGI gi )
		{
			UnityGIInput data = s.GIData;
			Input i = s.SurfInput;
			half4 c = 0;
			#ifdef UNITY_PASS_FORWARDBASE
			float ase_lightAtten = data.atten;
			if( _LightColor0.a == 0)
			ase_lightAtten = 0;
			#else
			float3 ase_lightAttenRGB = gi.light.color / ( ( _LightColor0.rgb ) + 0.000001 );
			float ase_lightAtten = max( max( ase_lightAttenRGB.r, ase_lightAttenRGB.g ), ase_lightAttenRGB.b );
			#endif
			#if defined(HANDLE_SHADOWS_BLENDING_IN_GI)
			half bakedAtten = UnitySampleBakedOcclusion(data.lightmapUV.xy, data.worldPos);
			float zDist = dot(_WorldSpaceCameraPos - data.worldPos, UNITY_MATRIX_V[2].xyz);
			float fadeDist = UnityComputeShadowFadeDistance(data.worldPos, zDist);
			ase_lightAtten = UnityMixRealtimeAndBakedShadows(data.atten, bakedAtten, UnityComputeShadowFade(fadeDist));
			#endif
			float2 uv_MainTex = i.uv_texcoord * _MainTex_ST.xy + _MainTex_ST.zw;
			float4 tex2DNode4 = tex2D( _MainTex, uv_MainTex );
			float4 temp_output_95_0 = ( _AddAlbedoColor + tex2DNode4 );
			float2 uv_BumpMap = i.uv_texcoord * _BumpMap_ST.xy + _BumpMap_ST.zw;
			float3 newWorldNormal19 = (WorldNormalVector( i , UnpackScaleNormal( tex2D( _BumpMap, uv_BumpMap ), _NormalLevel ) ));
			float3 normalizeResult18 = normalize( newWorldNormal19 );
			float3 Normal50 = normalizeResult18;
			float temp_output_27_0 = ( ( _FakeLightAngle * UNITY_PI ) / 180.0 );
			float4 appendResult17 = (float4(0.0 , cos( temp_output_27_0 ) , sin( temp_output_27_0 ) , 0.0));
			float3 ase_worldPos = i.worldPos;
			#if defined(LIGHTMAP_ON) && UNITY_VERSION < 560 //aseld
			float3 ase_worldlightDir = 0;
			#else //aseld
			float3 ase_worldlightDir = Unity_SafeNormalize( UnityWorldSpaceLightDir( ase_worldPos ) );
			#endif //aseld
			float4 ifLocalVar145 = 0;
			if( lerp(0.0,1.0,_FakeLight) > 0.0 )
				ifLocalVar145 = appendResult17;
			else if( lerp(0.0,1.0,_FakeLight) == 0.0 )
				ifLocalVar145 = float4( ase_worldlightDir , 0.0 );
			float dotResult10 = dot( float4( Normal50 , 0.0 ) , ifLocalVar145 );
			float temp_output_12_0 = (dotResult10*0.5 + 0.5);
			float ifLocalVar143 = 0;
			if( lerp(0.0,1.0,_FakeLight) > 0.0 )
				ifLocalVar143 = temp_output_12_0;
			else if( lerp(0.0,1.0,_FakeLight) == 0.0 )
				ifLocalVar143 = ( ase_lightAtten * temp_output_12_0 );
			float2 temp_cast_2 = (saturate( ifLocalVar143 )).xx;
			float2 uv_ShadowMask = i.uv_texcoord * _ShadowMask_ST.xy + _ShadowMask_ST.zw;
			float temp_output_2_0_g9 = tex2D( _ShadowMask, uv_ShadowMask ).r;
			float temp_output_3_0_g9 = ( 1.0 - temp_output_2_0_g9 );
			float3 appendResult7_g9 = (float3(temp_output_3_0_g9 , temp_output_3_0_g9 , temp_output_3_0_g9));
			float3 Mat85 = ( ( mul( UNITY_MATRIX_V, float4( Normal50 , 0.0 ) ).xyz * 0.5 ) + 0.5 );
			float2 uv_MetallicGlossMap = i.uv_texcoord * _MetallicGlossMap_ST.xy + _MetallicGlossMap_ST.zw;
			float4 tex2DNode52 = tex2D( _MetallicGlossMap, uv_MetallicGlossMap );
			float temp_output_58_0 = (0.1 + (tex2DNode52.a - 0.0) * (1.0 - 0.1) / (1.0 - 0.0));
			float temp_output_146_0 = (0.01 + (_Roughness - -1.0) * (1.0 - 0.01) / (1.0 - -1.0));
			float4 lerpResult137 = lerp( tex2D( _BlurEnvMatCap, Mat85.xy ) , tex2D( _EnvMatCap, Mat85.xy ) , pow( ( temp_output_58_0 * temp_output_146_0 ) , 3.0 ));
			float4 Tex87 = temp_output_95_0;
			float4 blendOpSrc131 = lerpResult137;
			float4 blendOpDest131 = (float4( 0,0,0,0 ) + (Tex87 - float4( 0,0,0,0 )) * (float4( 0.4980392,0.4980392,0.4980392,0 ) - float4( 0,0,0,0 )) / (float4( 1,1,1,0 ) - float4( 0,0,0,0 )));
			float4 lerpResult200 = lerp( ( saturate( (( blendOpDest131 > 0.5 ) ? ( 1.0 - ( 1.0 - 2.0 * ( blendOpDest131 - 0.5 ) ) * ( 1.0 - blendOpSrc131 ) ) : ( 2.0 * blendOpDest131 * blendOpSrc131 ) ) )) , lerpResult137 , 0.2573529);
			float4 clampResult203 = clamp( ( temp_output_95_0 + float4( 0.1254902,0.1254902,0.1254902,0 ) ) , float4( 0.1254902,0.1254902,0.1254902,0 ) , float4( 0.7843137,0.7843137,0.7843137,0 ) );
			float4 temp_output_201_0 = ( lerpResult200 * clampResult203 );
			float4 temp_output_99_0 = ( ( _Metalness + 1.0 ) * tex2DNode52 );
			float4 ifLocalVar103 = 0;
			if( _Metalness <= 0.0 )
				ifLocalVar103 = temp_output_99_0;
			else
				ifLocalVar103 = ( _Metalness + tex2DNode52 );
			float4 clampResult109 = clamp( ifLocalVar103 , float4( 0,0,0,0 ) , float4( 1,1,1,0 ) );
			float3 hsvTorgb101 = RGBToHSV( clampResult109.rgb );
			float temp_output_124_0 = ( 1.0 - hsvTorgb101.z );
			float4 lerpResult133 = lerp( temp_output_201_0 , float4( 1,1,1,0 ) , temp_output_124_0);
			float4 lerpResult130 = lerp( temp_output_201_0 , float4( 0,0,0,0 ) , temp_output_124_0);
			float4 clampResult194 = clamp( tex2D( _SpecularMatCap, Mat85.xy ) , float4( 0,0,0,0 ) , float4( 1,1,1,0 ) );
			float4 temp_cast_11 = (( temp_output_146_0 * 20.0 * temp_output_58_0 )).xxxx;
			float3 hsvTorgb65 = RGBToHSV( Tex87.rgb );
			float3 hsvTorgb69 = HSVToRGB( float3(hsvTorgb65.x,hsvTorgb65.y,1.0) );
			float temp_output_2_0_g8 = hsvTorgb101.z;
			float temp_output_3_0_g8 = ( 1.0 - temp_output_2_0_g8 );
			float3 appendResult7_g8 = (float3(temp_output_3_0_g8 , temp_output_3_0_g8 , temp_output_3_0_g8));
			float clampResult68 = clamp( ( ( _SpecularPower + temp_output_58_0 ) * temp_output_146_0 ) , 0.0 , 1.0 );
			float4 clampResult117 = clamp( ( tex2D( _ShadowMatCap, Mat85.xy ) + ( 1.0 - _ShadowMatPower ) ) , float4( 0,0,0,0 ) , float4( 1,1,1,0 ) );
			float2 uv_EmissionMap = i.uv_texcoord * _EmissionMap_ST.xy + _EmissionMap_ST.zw;
			c.rgb = ( ( ( ( temp_output_95_0 * float4( ( ( tex2D( _ToonRamp, temp_cast_2 ).rgb * temp_output_2_0_g9 ) + appendResult7_g9 ) , 0.0 ) * lerpResult133 ) + lerpResult130 + ( pow( clampResult194 , temp_cast_11 ) * float4( ( ( hsvTorgb69 * temp_output_2_0_g8 ) + appendResult7_g8 ) , 0.0 ) * (0.01 + (clampResult68 - 0.0) * (1.0 - 0.01) / (1.0 - 0.0)) ) ) * clampResult117 ) + ( tex2D( _EmissionMap, uv_EmissionMap ) * _EmissionPower ) ).rgb;
			c.a = 1;
			clip( tex2DNode4.a - _AlphaCutoff );
			return c;
		}

		inline void LightingStandardCustomLighting_GI( inout SurfaceOutputCustomLightingCustom s, UnityGIInput data, inout UnityGI gi )
		{
			s.GIData = data;
		}

		void surf( Input i , inout SurfaceOutputCustomLightingCustom o )
		{
			o.SurfInput = i;
			o.Normal = float3(0,0,1);
		}

		ENDCG
		CGPROGRAM
		#pragma surface surf StandardCustomLighting keepalpha fullforwardshadows noforwardadd 

		ENDCG
		Pass
		{
			Name "ShadowCaster"
			Tags{ "LightMode" = "ShadowCaster" }
			ZWrite On
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma target 4.6
			#pragma multi_compile_shadowcaster
			#pragma multi_compile UNITY_PASS_SHADOWCASTER
			#pragma skip_variants FOG_LINEAR FOG_EXP FOG_EXP2
			#include "HLSLSupport.cginc"
			#if ( SHADER_API_D3D11 || SHADER_API_GLCORE || SHADER_API_GLES3 || SHADER_API_METAL || SHADER_API_VULKAN )
				#define CAN_SKIP_VPOS
			#endif
			#include "UnityCG.cginc"
			#include "Lighting.cginc"
			#include "UnityPBSLighting.cginc"
			struct v2f
			{
				V2F_SHADOW_CASTER;
				float2 customPack1 : TEXCOORD1;
				float4 tSpace0 : TEXCOORD2;
				float4 tSpace1 : TEXCOORD3;
				float4 tSpace2 : TEXCOORD4;
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};
			v2f vert( appdata_full v )
			{
				v2f o;
				UNITY_SETUP_INSTANCE_ID( v );
				UNITY_INITIALIZE_OUTPUT( v2f, o );
				UNITY_TRANSFER_INSTANCE_ID( v, o );
				Input customInputData;
				float3 worldPos = mul( unity_ObjectToWorld, v.vertex ).xyz;
				half3 worldNormal = UnityObjectToWorldNormal( v.normal );
				half3 worldTangent = UnityObjectToWorldDir( v.tangent.xyz );
				half tangentSign = v.tangent.w * unity_WorldTransformParams.w;
				half3 worldBinormal = cross( worldNormal, worldTangent ) * tangentSign;
				o.tSpace0 = float4( worldTangent.x, worldBinormal.x, worldNormal.x, worldPos.x );
				o.tSpace1 = float4( worldTangent.y, worldBinormal.y, worldNormal.y, worldPos.y );
				o.tSpace2 = float4( worldTangent.z, worldBinormal.z, worldNormal.z, worldPos.z );
				o.customPack1.xy = customInputData.uv_texcoord;
				o.customPack1.xy = v.texcoord;
				TRANSFER_SHADOW_CASTER_NORMALOFFSET( o )
				return o;
			}
			half4 frag( v2f IN
			#if !defined( CAN_SKIP_VPOS )
			, UNITY_VPOS_TYPE vpos : VPOS
			#endif
			) : SV_Target
			{
				UNITY_SETUP_INSTANCE_ID( IN );
				Input surfIN;
				UNITY_INITIALIZE_OUTPUT( Input, surfIN );
				surfIN.uv_texcoord = IN.customPack1.xy;
				float3 worldPos = float3( IN.tSpace0.w, IN.tSpace1.w, IN.tSpace2.w );
				half3 worldViewDir = normalize( UnityWorldSpaceViewDir( worldPos ) );
				surfIN.worldPos = worldPos;
				surfIN.worldNormal = float3( IN.tSpace0.z, IN.tSpace1.z, IN.tSpace2.z );
				surfIN.internalSurfaceTtoW0 = IN.tSpace0.xyz;
				surfIN.internalSurfaceTtoW1 = IN.tSpace1.xyz;
				surfIN.internalSurfaceTtoW2 = IN.tSpace2.xyz;
				SurfaceOutputCustomLightingCustom o;
				UNITY_INITIALIZE_OUTPUT( SurfaceOutputCustomLightingCustom, o )
				surf( surfIN, o );
				UnityGI gi;
				UNITY_INITIALIZE_OUTPUT( UnityGI, gi );
				o.Alpha = LightingStandardCustomLighting( o, worldViewDir, gi ).a;
				#if defined( CAN_SKIP_VPOS )
				float2 vpos = IN.pos;
				#endif
				SHADOW_CASTER_FRAGMENT( IN )
			}
			ENDCG
		}
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=15600
227;220;1686;770;-812.5951;455.9739;1;True;True
Node;AmplifyShaderEditor.CommentaryNode;1;-2395.438,-156.9246;Float;False;1380.644;1001.628;Comment;22;10;145;17;144;142;28;25;27;50;26;18;22;19;20;118;150;151;168;185;189;190;191;N . L;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;118;-2256.734,-24.71124;Float;False;Property;_NormalLevel;Normal Level;11;0;Create;True;0;0;False;0;1;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;20;-1939.014,-91.63982;Float;True;Property;_BumpMap;NormalMap;10;1;[Normal];Create;False;0;0;False;0;None;0517bb00939ecbe4299fc94eeb05a54f;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;22;-2266.648,108.6081;Float;False;Property;_FakeLightAngle;FakeLightAngle;1;0;Create;True;0;0;False;0;45;45;0;180;0;1;FLOAT;0
Node;AmplifyShaderEditor.WorldNormalVector;19;-1620.231,-86.3997;Float;False;False;1;0;FLOAT3;0,0,0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.PiNode;26;-2240.83,186.4067;Float;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.NormalizeNode;18;-1405.576,-75.78049;Float;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.CommentaryNode;75;-1826.683,-1027.361;Float;False;894.1417;594.0653;;7;85;84;83;82;81;79;86;MatUV;1,0,0,1;0;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;27;-2215.633,268.0521;Float;False;2;0;FLOAT;0;False;1;FLOAT;180;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;86;-1521.851,-851.5272;Float;True;50;Normal;0;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;50;-1412.722,21.10414;Float;False;Normal;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.ViewMatrixNode;79;-1493.614,-974.7091;Float;False;0;1;FLOAT4x4;0
Node;AmplifyShaderEditor.CosOpNode;25;-2064.913,242.1599;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SinOpNode;28;-2064.104,310.3438;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;51;-881.9073,-2028.276;Float;False;1745.469;811.2482;;30;73;69;68;67;65;62;61;59;58;57;54;53;52;97;99;101;103;104;105;106;109;74;138;139;146;169;192;194;199;64;Metall;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;82;-1262.426,-672.4368;Float;False;Constant;_Float4;Float 4;-1;0;Create;True;0;0;False;0;0.5;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;81;-1290.794,-956.1752;Float;False;2;2;0;FLOAT4x4;0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.WorldSpaceLightDirHlpNode;144;-2149.13,397.6562;Float;False;True;1;0;FLOAT;0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.DynamicAppendNode;17;-1905.063,214.4191;Float;False;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.ToggleSwitchNode;142;-1952.639,101.9845;Float;False;Property;_FakeLight;FakeLight;0;0;Create;True;0;0;False;0;0;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;83;-1091.053,-840.3111;Float;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SamplerNode;52;-859.2105,-1982.386;Float;True;Property;_MetallicGlossMap;MetallicMap;6;0;Create;False;0;0;False;0;None;c93e9521fc509c14b848ad77e7511ed9;True;0;False;black;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;0,0;False;1;FLOAT2;1,0;False;2;FLOAT;1;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;57;-652.89,-1532.651;Float;False;Property;_Roughness;Roughness;8;0;Create;True;0;0;False;0;0;0;-1;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.ConditionalIfNode;145;-1734.902,191.1005;Float;False;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT4;0,0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.CommentaryNode;2;-939.1909,-268.1525;Float;False;723.599;290;Also know as Lambert Wrap or Half Lambert;6;13;12;11;140;141;143;Diffuse Wrap;1,1,1,1;0;0
Node;AmplifyShaderEditor.TFHCRemapNode;58;-207.9643,-1776.902;Float;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0.1;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;97;-460.972,-1981.964;Float;False;Property;_Metalness;Metalness;7;0;Create;True;0;0;False;0;0;0;-1;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;146;-294.4209,-1595.254;Float;False;5;0;FLOAT;0;False;1;FLOAT;-1;False;2;FLOAT;1;False;3;FLOAT;0.01;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;119;-626.1553,-1173.404;Float;False;1462.805;649.2731;;12;204;87;137;130;133;124;201;200;131;120;136;121;Environment ;0,1,0.04827595,1;0;0
Node;AmplifyShaderEditor.ColorNode;94;-70.40488,-469.7973;Float;False;Property;_AddAlbedoColor;AddAlbedoColor;14;0;Create;True;0;0;False;0;0,0,0,0;0.1544118,0.1544118,0.1544118,0;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;4;-176.1395,-306.6778;Float;True;Property;_MainTex;Albedo;2;0;Create;False;0;0;False;0;None;98fc481b39349ed44a20da38115d6368;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;1;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;84;-1072.223,-722.7397;Float;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleAddOpNode;104;-449.4674,-1897.311;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;11;-920.0852,-76.25168;Float;False;Constant;_WrapperValue;Wrapper Value;0;0;Create;True;0;0;False;0;0.5;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.DotProductOpNode;10;-1174.261,24.11198;Float;False;2;0;FLOAT3;0,0,0;False;1;FLOAT4;0,0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;138;-119.9187,-1371.753;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;95;204.3574,-396.5319;Float;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;121;-496.3908,-1106.856;Float;False;85;Mat;0;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;85;-1159.624,-561.3246;Float;False;Mat;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.LightAttenuation;140;-884.829,-212.2084;Float;False;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;99;-317.7003,-1864.499;Float;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;105;-192.3855,-1930.658;Float;False;2;2;0;FLOAT;0;False;1;COLOR;1,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ScaleAndOffsetNode;12;-735.266,-104.6129;Float;False;3;0;FLOAT;0;False;1;FLOAT;1;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;136;-380.5929,-801.5812;Float;True;Property;_BlurEnvMatCap;BlurEnvMatCap;16;1;[NoScaleOffset];Create;True;0;0;False;0;a8adda796be2a884fb969bcd633ac771;a8adda796be2a884fb969bcd633ac771;True;0;False;black;Auto;False;Object;-1;MipLevel;Texture2D;6;0;SAMPLER2D;0,0;False;1;FLOAT2;1,0;False;2;FLOAT;1;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.PowerNode;139;40.93901,-1327.789;Float;False;2;0;FLOAT;0;False;1;FLOAT;3;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;87;-74.53995,-631.8658;Float;False;Tex;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;120;-376.311,-991.368;Float;True;Property;_EnvMatCap;EnvMatCap;15;1;[NoScaleOffset];Create;True;0;0;False;0;befa03684ff9916469ae2097e5fd1991;befa03684ff9916469ae2097e5fd1991;True;0;False;black;Auto;False;Object;-1;MipLevel;Texture2D;6;0;SAMPLER2D;0,0;False;1;FLOAT2;1,0;False;2;FLOAT;1;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;141;-635.424,-228.0708;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ConditionalIfNode;103;64.90524,-1940.251;Float;False;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;COLOR;0,0,0,0;False;3;COLOR;0,0,0,0;False;4;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;53;-137.3099,-1435.631;Float;False;Property;_SpecularPower;SpecularPower;9;0;Create;True;0;0;False;0;0;0;-1;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;204;184.5505,-699.826;Float;False;5;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;1,1,1,0;False;3;COLOR;0,0,0,0;False;4;COLOR;0.4980392,0.4980392,0.4980392,0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;137;215.0999,-820.757;Float;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;54;-862.9879,-1776.939;Float;False;87;Tex;0;1;COLOR;0
Node;AmplifyShaderEditor.ClampOpNode;109;234.6882,-1943.395;Float;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;1,1,1,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;62;38.00551,-1561.72;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;202;406.5505,-443.826;Float;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0.1254902,0.1254902,0.1254902,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;199;-742.6515,-1440.52;Float;False;85;Mat;0;1;FLOAT3;0
Node;AmplifyShaderEditor.BlendOpsNode;131;409.1222,-907.526;Float;False;Overlay;True;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ConditionalIfNode;143;-490.3977,-211.2766;Float;False;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;13;-354.7024,-62.67037;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;200;447.3287,-796.9662;Float;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0.2573529;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;64;-543.6315,-1422.016;Float;True;Property;_SpecularMatCap;AddMatCap;17;1;[NoScaleOffset];Create;False;0;0;False;0;eec98e2aebe321647846a3440b863649;eec98e2aebe321647846a3440b863649;True;0;False;black;Auto;False;Object;-1;MipLevel;Texture2D;6;0;SAMPLER2D;0,0;False;1;FLOAT2;1,0;False;2;FLOAT;1;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;59;-8.122882,-1775.934;Float;False;Constant;_Float1;Float 1;7;1;[HideInInspector];Create;True;0;0;False;0;20;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RGBToHSVNode;101;393.7771,-1897.624;Float;False;1;0;FLOAT3;0,0,0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.ClampOpNode;203;547.5505,-538.826;Float;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0.1254902,0.1254902,0.1254902,0;False;2;COLOR;0.7843137,0.7843137,0.7843137,0;False;1;COLOR;0
Node;AmplifyShaderEditor.CommentaryNode;110;-921.2632,276.2547;Float;False;1025.446;781.8519;;5;112;117;115;113;114;Shadow;0.8309207,0,1,1;0;0
Node;AmplifyShaderEditor.RGBToHSVNode;65;-695.9413,-1769.156;Float;False;1;0;FLOAT3;0,0,0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;192;149.6609,-1500.467;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;5;-70.53638,-112.2785;Float;True;Property;_ToonRamp;Toon Ramp;4;0;Create;True;0;0;False;0;96ac985743c40434ca655f949d3686a7;29b0a25e9fbde404da87cadcd89cd6bb;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;1;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ClampOpNode;194;383.0335,-1688.54;Float;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;1,1,1,0;False;1;COLOR;0
Node;AmplifyShaderEditor.OneMinusNode;124;405.0994,-1084.035;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;147;-66.19984,73.49487;Float;True;Property;_ShadowMask;ShadowMask;5;0;Create;True;0;0;False;0;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ClampOpNode;68;315.8786,-1556.916;Float;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.HSVToRGBNode;69;-438.4432,-1733.705;Float;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RangedFloatNode;112;-780.357,608.0402;Float;False;Property;_ShadowMatPower;MultiplyMatPower;19;0;Create;False;0;0;False;0;0.5;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;111;-934.5845,434.9137;Float;False;85;Mat;0;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;201;457.3905,-677.0955;Float;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;61;44.65067,-1690.691;Float;False;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;106;599.6617,-1749.868;Float;False;Lerp White To;-1;;8;047d7c189c36a62438973bad9d37b1c2;0;2;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.PowerNode;67;554.9402,-1644.776;Float;False;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.FunctionNode;148;260.7985,-77.62753;Float;False;Lerp White To;-1;;9;047d7c189c36a62438973bad9d37b1c2;0;2;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.LerpOp;133;678.6913,-732.6982;Float;False;3;0;COLOR;0,0,0,0;False;1;COLOR;1,1,1,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.OneMinusNode;113;-419.003,590.3369;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;114;-744.2682,342.0633;Float;True;Property;_ShadowMatCap;MultiplyMatCap;18;1;[NoScaleOffset];Create;False;0;0;False;0;2a2acaf25cb85224189b9b65f7a94656;2a2acaf25cb85224189b9b65f7a94656;True;0;False;white;Auto;False;Object;-1;MipLevel;Texture2D;6;0;SAMPLER2D;0,0;False;1;FLOAT2;1,0;False;2;FLOAT;1;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TFHCRemapNode;73;487.0806,-1537.121;Float;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0.01;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;15;826.1669,-261.6844;Float;False;3;3;0;COLOR;0,0,0,0;False;1;FLOAT3;0,0,0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;115;-402.3666,478.5171;Float;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;130;678.2639,-864.6846;Float;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;74;734.5607,-1588.352;Float;False;3;3;0;COLOR;0,0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;92;765.9691,102.9626;Float;False;Property;_EmissionPower;EmissionPower;13;0;Create;True;0;0;False;0;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;88;1254.637,-403.667;Float;False;3;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;91;608.9943,-117.3761;Float;True;Property;_EmissionMap;EmissionMap;12;0;Create;False;0;0;False;0;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ClampOpNode;117;-400.3338,347.0493;Float;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;1,1,1,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;93;971.6868,-28.9011;Float;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;205;1404.146,-376.8851;Float;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;169;204.5975,-1772.239;Float;False;168;Spec;0;1;FLOAT;0
Node;AmplifyShaderEditor.NegateNode;190;-1519.997,255.5909;Float;False;1;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleAddOpNode;206;1566.142,-301.6351;Float;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;96;1541.03,-54.53763;Float;False;Property;_AlphaCutoff;Alpha Cutoff;3;0;Create;True;0;0;False;0;0.5;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;191;-1458.393,563.3043;Float;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.ReflectOpNode;189;-1786.439,419.6183;Float;True;2;0;FLOAT4;0,0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;168;-1268.629,712.8616;Float;False;Spec;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;185;-1292.91,551.1666;Float;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.ViewDirInputsCoordNode;151;-1714.524,636.2087;Float;False;World;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.DotProductOpNode;150;-1477.163,348.9095;Float;True;2;0;FLOAT4;0,0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;1976.385,-435.4264;Float;False;True;6;Float;ASEMaterialInspector;0;0;CustomLighting;YSHT Shaders/PBTShader;False;False;False;False;False;False;False;False;False;False;False;True;False;False;True;False;False;False;False;False;Off;1;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Custom;0.5;True;True;0;True;TransparentCutout;;Geometry;All;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;0;4;10;25;True;0.5;True;0;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;True;96;0;0;0;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;20;5;118;0
WireConnection;19;0;20;0
WireConnection;26;0;22;0
WireConnection;18;0;19;0
WireConnection;27;0;26;0
WireConnection;50;0;18;0
WireConnection;25;0;27;0
WireConnection;28;0;27;0
WireConnection;81;0;79;0
WireConnection;81;1;86;0
WireConnection;17;1;25;0
WireConnection;17;2;28;0
WireConnection;83;0;81;0
WireConnection;83;1;82;0
WireConnection;145;0;142;0
WireConnection;145;2;17;0
WireConnection;145;3;144;0
WireConnection;58;0;52;4
WireConnection;146;0;57;0
WireConnection;84;0;83;0
WireConnection;84;1;82;0
WireConnection;104;0;97;0
WireConnection;10;0;50;0
WireConnection;10;1;145;0
WireConnection;138;0;58;0
WireConnection;138;1;146;0
WireConnection;95;0;94;0
WireConnection;95;1;4;0
WireConnection;85;0;84;0
WireConnection;99;0;104;0
WireConnection;99;1;52;0
WireConnection;105;0;97;0
WireConnection;105;1;52;0
WireConnection;12;0;10;0
WireConnection;12;1;11;0
WireConnection;12;2;11;0
WireConnection;136;1;121;0
WireConnection;139;0;138;0
WireConnection;87;0;95;0
WireConnection;120;1;121;0
WireConnection;141;0;140;0
WireConnection;141;1;12;0
WireConnection;103;0;97;0
WireConnection;103;2;105;0
WireConnection;103;3;99;0
WireConnection;103;4;99;0
WireConnection;204;0;87;0
WireConnection;137;0;136;0
WireConnection;137;1;120;0
WireConnection;137;2;139;0
WireConnection;109;0;103;0
WireConnection;62;0;53;0
WireConnection;62;1;58;0
WireConnection;202;0;95;0
WireConnection;131;0;137;0
WireConnection;131;1;204;0
WireConnection;143;0;142;0
WireConnection;143;2;12;0
WireConnection;143;3;141;0
WireConnection;13;0;143;0
WireConnection;200;0;131;0
WireConnection;200;1;137;0
WireConnection;64;1;199;0
WireConnection;101;0;109;0
WireConnection;203;0;202;0
WireConnection;65;0;54;0
WireConnection;192;0;62;0
WireConnection;192;1;146;0
WireConnection;5;1;13;0
WireConnection;194;0;64;0
WireConnection;124;0;101;3
WireConnection;68;0;192;0
WireConnection;69;0;65;1
WireConnection;69;1;65;2
WireConnection;201;0;200;0
WireConnection;201;1;203;0
WireConnection;61;0;146;0
WireConnection;61;1;59;0
WireConnection;61;2;58;0
WireConnection;106;1;69;0
WireConnection;106;2;101;3
WireConnection;67;0;194;0
WireConnection;67;1;61;0
WireConnection;148;1;5;0
WireConnection;148;2;147;1
WireConnection;133;0;201;0
WireConnection;133;2;124;0
WireConnection;113;0;112;0
WireConnection;114;1;111;0
WireConnection;73;0;68;0
WireConnection;15;0;95;0
WireConnection;15;1;148;0
WireConnection;15;2;133;0
WireConnection;115;0;114;0
WireConnection;115;1;113;0
WireConnection;130;0;201;0
WireConnection;130;2;124;0
WireConnection;74;0;67;0
WireConnection;74;1;106;0
WireConnection;74;2;73;0
WireConnection;88;0;15;0
WireConnection;88;1;130;0
WireConnection;88;2;74;0
WireConnection;117;0;115;0
WireConnection;93;0;91;0
WireConnection;93;1;92;0
WireConnection;205;0;88;0
WireConnection;205;1;117;0
WireConnection;190;0;145;0
WireConnection;206;0;205;0
WireConnection;206;1;93;0
WireConnection;191;0;150;0
WireConnection;189;0;190;0
WireConnection;189;1;19;0
WireConnection;168;0;185;0
WireConnection;185;0;191;0
WireConnection;150;0;189;0
WireConnection;150;1;151;0
WireConnection;0;10;4;4
WireConnection;0;13;206;0
ASEEND*/
//CHKSM=1E6E44C1B4425DA2FB88403AAAD8F73446EF34B7