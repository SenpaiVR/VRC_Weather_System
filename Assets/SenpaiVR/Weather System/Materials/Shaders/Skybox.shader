// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "SenpaiVR/Skybox"
{
	Properties
	{
		_GroundColor("Ground Color", Color) = (0,0,0,0)
		_HorizonZenithColorBlend("Horizon / Zenith Color Blend", Range( 0.1 , 2)) = 0.1
		[HDR]_DayHorizonColor("Day Horizon Color", Color) = (0.3137255,0.4588235,0.8,0)
		[HDR]_DayZenithColor("Day Zenith Color", Color) = (0.02745098,0.1764706,0.7450981,0)
		[HDR]_NightHorizonColor("Night Horizon Color", Color) = (0.08627451,0.07843138,0.1333333,0)
		[HDR]_NightZenithColor("Night Zenith Color", Color) = (0.1019608,0.01568628,0.1019608,0)
		_HorizonDesaturatiotnFalloff("Horizon Desaturatiotn Falloff", Range( 0 , 10)) = 3
		_HorizonSaturationAmount("Horizon Saturation Amount", Range( 0 , 1)) = 0.3
		[HDR]_SunZenithColor("Sun Zenith Color", Color) = (136.575,114.4084,61.4945,0)
		[HDR]_SunHorizonColor("Sun Horizon Color", Color) = (98.45185,43.81365,18.55637,0)
		_SunSize("Sun Size", Range( 0 , 1)) = 0.004
		_SunFalloff("Sun Falloff", Float) = 2
		_SunsetHorizonFalloff("Sunset Horizon Falloff", Range( 0.01 , 1)) = 0.5
		_SunsetVerticalFalloff("Sunset Vertical Falloff", Range( 0.01 , 1)) = 0.4
		_SunsetRadialFalloff("Sunset Radial Falloff", Range( 0.01 , 1)) = 0.2
		_SunsetIntensity("Sunset Intensity", Range( 0 , 1)) = 0.1
		_StarDaytimeBrightness("Star Daytime Brightness", Range( 0 , 1)) = 0.1
		_Declination("_Declination", Range( -90 , 90)) = -58
		_WorldRotation("_WorldRotation", Range( 0 , 360)) = 0
		_North("_North", Range( 0 , 360)) = 0
		_GroundAlpha("Ground Alpha", Range( 0 , 1)) = 0
		_StarBrightness("Star Brightness", Range( 0 , 5)) = 0
		[HDR]_starswithfurtherstars("stars with further stars", 2D) = "black" {}
		_ConstelationMap("Constelation Map", 2D) = "white" {}
		[HDR]_Stars("Stars", 2D) = "black" {}
		_ShowGalexy("Show Galexy", Range( 0 , 1)) = 0
		_ShowConstilationMap("Show Constilation Map", Range( 0 , 1)) = 0
		_FarStars("FarStars", Range( 0 , 1)) = 0
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Transparent+0" "IsEmissive" = "true"  }
		Cull Back
		CGPROGRAM
		#include "UnityCG.cginc"
		#pragma target 4.6
		#pragma surface surf Unlit keepalpha addshadow fullforwardshadows 
		struct Input
		{
			float3 worldPos;
		};

		uniform float4 _GroundColor;
		uniform float _StarDaytimeBrightness;
		uniform sampler2D _starswithfurtherstars;
		uniform float _WorldRotation;
		uniform float _Declination;
		uniform float _North;
		uniform sampler2D _Stars;
		uniform float _ShowGalexy;
		uniform float _FarStars;
		uniform float _StarBrightness;
		uniform sampler2D _ConstelationMap;
		uniform float _ShowConstilationMap;
		uniform float4 _NightHorizonColor;
		uniform float4 _NightZenithColor;
		uniform float _HorizonZenithColorBlend;
		uniform float4 _DayHorizonColor;
		uniform float4 _DayZenithColor;
		uniform float _HorizonSaturationAmount;
		uniform float _HorizonDesaturatiotnFalloff;
		uniform float4 _SunHorizonColor;
		uniform float4 _SunZenithColor;
		uniform float _SunSize;
		uniform float _SunFalloff;
		uniform float _SunsetRadialFalloff;
		uniform float _SunsetHorizonFalloff;
		uniform float _SunsetVerticalFalloff;
		uniform float _SunsetIntensity;
		uniform float _GroundAlpha;


		float3 RotateAroundAxis( float3 center, float3 original, float3 u, float angle )
		{
			original -= center;
			float C = cos( angle );
			float S = sin( angle );
			float t = 1 - C;
			float m00 = t * u.x * u.x + C;
			float m01 = t * u.x * u.y - S * u.z;
			float m02 = t * u.x * u.z + S * u.y;
			float m10 = t * u.x * u.y + S * u.z;
			float m11 = t * u.y * u.y + C;
			float m12 = t * u.y * u.z - S * u.x;
			float m20 = t * u.x * u.z - S * u.y;
			float m21 = t * u.y * u.z + S * u.x;
			float m22 = t * u.z * u.z + C;
			float3x3 finalMatrix = float3x3( m00, m01, m02, m10, m11, m12, m20, m21, m22 );
			return mul( finalMatrix, original ) + center;
		}


		inline half4 LightingUnlit( SurfaceOutput s, half3 lightDir, half atten )
		{
			return half4 ( 0, 0, 0, s.Alpha );
		}

		void surf( Input i , inout SurfaceOutput o )
		{
			float4 varGroundColor529 = _GroundColor;
			float4 break152 = varGroundColor529;
			float3 appendResult153 = (float3(break152.r , break152.g , break152.b));
			float3 ase_worldPos = i.worldPos;
			#if defined(LIGHTMAP_ON) && UNITY_VERSION < 560 //aseld
			float3 ase_worldlightDir = 0;
			#else //aseld
			float3 ase_worldlightDir = normalize( UnityWorldSpaceLightDir( ase_worldPos ) );
			#endif //aseld
			float smoothstepResult984 = smoothstep( 0.1 , -0.4 , ase_worldlightDir.y);
			float varStarDaytimeBrightness499 = _StarDaytimeBrightness;
			float3 normalizeResult768 = normalize( ase_worldPos );
			float3 rotatedValue1129 = RotateAroundAxis( float3( 0,0,0 ), normalizeResult768, float3( 0,1,0 ), radians( _North ) );
			float3 rotatedValue1105 = RotateAroundAxis( float3( 0,0,0 ), rotatedValue1129, normalize( float3( 1,0,0 ) ), radians( ( _Declination + 90.0 ) ) );
			float3 rotatedValue878 = RotateAroundAxis( float3( 0,0,0 ), rotatedValue1105, float3( 0,1,0 ), radians( _WorldRotation ) );
			float3 break926 = rotatedValue878;
			float2 appendResult930 = (float2(( atan2( break926.x , break926.z ) / 6.28318548202515 ) , ( ( acos( break926.y ) / ( UNITY_PI / 2.0 ) ) / 2.0 )));
			float4 blendOpSrc1054 = tex2D( _starswithfurtherstars, appendResult930 );
			float4 blendOpDest1054 = tex2D( _Stars, appendResult930 );
			float4 lerpBlendMode1054 = lerp(blendOpDest1054,( blendOpDest1054 - blendOpSrc1054 ),( 1.0 - _ShowGalexy ));
			float4 temp_output_1054_0 = ( saturate( lerpBlendMode1054 ));
			float4 blendOpSrc1116 = temp_output_1054_0;
			float4 blendOpDest1116 = ( temp_output_1054_0 * float4( 1,1,1,0 ) );
			float temp_output_1120_0 = ( 1.0 - _FarStars );
			float4 lerpBlendMode1116 = lerp(blendOpDest1116, round( 0.5 * ( blendOpSrc1116 + blendOpDest1116 ) ),temp_output_1120_0);
			float4 break1121 = ( saturate( lerpBlendMode1116 ));
			float3 appendResult1122 = (float3(break1121.r , break1121.g , break1121.b));
			float3 desaturateInitialColor1117 = appendResult1122;
			float desaturateDot1117 = dot( desaturateInitialColor1117, float3( 0.299, 0.587, 0.114 ));
			float3 desaturateVar1117 = lerp( desaturateInitialColor1117, desaturateDot1117.xxx, temp_output_1120_0 );
			float4 Stars421 = ( saturate( (varStarDaytimeBrightness499 + (smoothstepResult984 - 0.0) * (1.0 - varStarDaytimeBrightness499) / (1.0 - 0.0)) ) * ( float4( ( desaturateVar1117 * _StarBrightness ) , 0.0 ) + ( tex2D( _ConstelationMap, appendResult930 ) * _ShowConstilationMap ) ) );
			float4 varNightHorizonColor519 = _NightHorizonColor;
			float4 varNightZenithColor521 = _NightZenithColor;
			float4 transform331 = mul(unity_WorldToObject,float4( ase_worldPos , 0.0 ));
			float4 normalizeResult328 = normalize( transform331 );
			float4 break327 = normalizeResult328;
			float4 normalizeResult322 = normalize( transform331 );
			float2 appendResult318 = (float2(( atan2( break327.x , break327.z ) / 6.28318548202515 ) , ( asin( normalizeResult322.y ) / ( UNITY_PI / 2.0 ) )));
			float2 SkyboxUV332 = appendResult318;
			float varHorizonZenithColorBlend517 = _HorizonZenithColorBlend;
			float temp_output_111_0 = pow( saturate( SkyboxUV332.y ) , varHorizonZenithColorBlend517 );
			float4 lerpResult118 = lerp( varNightHorizonColor519 , varNightZenithColor521 , temp_output_111_0);
			float4 varDayHorizonColor523 = _DayHorizonColor;
			float4 varDayZenithColor525 = _DayZenithColor;
			float4 lerpResult114 = lerp( varDayHorizonColor523 , varDayZenithColor525 , temp_output_111_0);
			float smoothstepResult122 = smoothstep( -0.3 , 0.0 , ase_worldlightDir.y);
			float4 lerpResult121 = lerp( lerpResult118 , lerpResult114 , smoothstepResult122);
			float4 temp_output_127_0 = ( Stars421 + lerpResult121 );
			float3 temp_output_1_0_g207 = lerpResult121.rgb;
			float dotResult4_g207 = dot( temp_output_1_0_g207 , float3(0.2126729,0.7151522,0.072175) );
			float3 temp_cast_4 = (dotResult4_g207).xxx;
			float varHorizonSaturationAmount531 = _HorizonSaturationAmount;
			float varHorizonDesaturatiotnFalloff533 = _HorizonDesaturatiotnFalloff;
			float4 lerpResult208 = lerp( temp_output_127_0 , float4( ( ( temp_output_1_0_g207 - temp_cast_4 ) * ( dotResult4_g207 + varHorizonSaturationAmount531 ) ) , 0.0 ) , pow( ( 1.0 - saturate( SkyboxUV332.y ) ) , ( varHorizonDesaturatiotnFalloff533 * varHorizonDesaturatiotnFalloff533 ) ));
			float4 varSunHorizonColor501 = _SunHorizonColor;
			float4 varSunZenithColor503 = _SunZenithColor;
			float smoothstepResult362 = smoothstep( 0.1 , 0.3 , ase_worldlightDir.y);
			float4 lerpResult361 = lerp( varSunHorizonColor501 , varSunZenithColor503 , smoothstepResult362);
			float3 normalizeResult424 = normalize( ase_worldPos );
			float3 normalizeResult425 = normalize( ase_worldlightDir );
			float2 _Vector0 = float2(0,2);
			float2 _Vector1 = float2(0,1);
			float GetSkyboxLightDistance432 = saturate( (_Vector1.x + (distance( normalizeResult424 , normalizeResult425 ) - _Vector0.x) * (_Vector1.y - _Vector1.x) / (_Vector0.y - _Vector0.x)) );
			float varSunSize507 = _SunSize;
			float varSunFalloff505 = _SunFalloff;
			float varSunsetRadialFalloff515 = _SunsetRadialFalloff;
			float smoothstepResult342 = smoothstep( 0.5 , 0.0 , ase_worldlightDir.y);
			float smoothstepResult341 = smoothstep( -0.2 , 0.0 , ase_worldlightDir.y);
			float temp_output_356_0 = ( smoothstepResult342 * smoothstepResult341 );
			float varSunsetHorizonFalloff513 = _SunsetHorizonFalloff;
			float temp_output_348_0 = pow( GetSkyboxLightDistance432 , varSunsetHorizonFalloff513 );
			float varSunsetVerticalFalloff511 = _SunsetVerticalFalloff;
			float smoothstepResult346 = smoothstep( temp_output_348_0 , 1.0 , ( 1.0 - pow( abs( SkyboxUV332.y ) , varSunsetVerticalFalloff511 ) ));
			float varSunsetIntensity509 = _SunsetIntensity;
			float4 Sun377 = ( ( lerpResult361 * pow( ( 1.0 - pow( GetSkyboxLightDistance432 , varSunSize507 ) ) , max( varSunFalloff505 , 0.0 ) ) ) + ( varSunHorizonColor501 * ( ( ( ( 1.0 - pow( GetSkyboxLightDistance432 , varSunsetRadialFalloff515 ) ) * temp_output_356_0 ) + ( temp_output_356_0 * saturate( ( ( 1.0 - temp_output_348_0 ) * smoothstepResult346 ) ) ) ) * varSunsetIntensity509 ) ) );
			float smoothstepResult169 = smoothstep( 0.0 , 0.0 , SkyboxUV332.y);
			float lerpResult968 = lerp( _GroundAlpha , 1.0 , smoothstepResult169);
			float4 lerpResult145 = lerp( float4( appendResult153 , 0.0 ) , ( lerpResult208 + Sun377 ) , lerpResult968);
			o.Emission = lerpResult145.rgb;
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18935
-2560;0;2560;1379;3434.652;319.3691;5.137388;True;False
Node;AmplifyShaderEditor.CommentaryNode;333;2256,4128;Inherit;False;1395.29;473.416;Comment;15;332;318;320;329;321;319;323;322;324;325;326;327;328;331;330;SkyboxUV;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;141;228.527,2949.478;Inherit;False;4007.438;676.0924;;53;421;1128;993;1066;1004;1055;1120;1118;1127;1125;1126;1124;1117;1122;1121;1119;1116;1067;1068;1054;1060;1059;992;988;994;1065;984;986;987;1051;1047;930;936;928;927;931;935;933;932;926;934;878;880;1105;1106;768;774;1107;832;877;1129;1130;1131;Stars;1,1,1,1;0;0
Node;AmplifyShaderEditor.WorldPosInputsNode;330;2272,4192;Inherit;True;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RangedFloatNode;877;529.4919,3486.955;Inherit;False;Property;_Declination;_Declination;46;0;Create;True;0;0;0;False;0;False;-58;39.6;-90;90;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;1131;516.4512,3194.015;Inherit;False;Property;_North;_North;48;0;Create;True;0;0;0;False;0;False;0;0;0;360;0;1;FLOAT;0
Node;AmplifyShaderEditor.WorldPosInputsNode;832;237.4918,2998.955;Inherit;True;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.WorldToObjectTransfNode;331;2496,4192;Inherit;True;1;0;FLOAT4;0,0,0,1;False;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.NormalizeNode;322;2752,4288;Inherit;False;False;1;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.NormalizeNode;328;2752,4208;Inherit;False;False;1;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleAddOpNode;1107;523.4919,3413.955;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;90;False;1;FLOAT;0
Node;AmplifyShaderEditor.NormalizeNode;768;301.4918,3174.955;Inherit;False;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RadiansOpNode;1130;654.4509,3125.015;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.BreakToComponentsNode;327;2896,4208;Inherit;False;FLOAT4;1;0;FLOAT4;0,0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.RangedFloatNode;774;823.4922,3477.955;Inherit;False;Property;_WorldRotation;_WorldRotation;47;0;Create;True;0;0;0;False;0;False;0;189.0142;0;360;0;1;FLOAT;0
Node;AmplifyShaderEditor.RadiansOpNode;1106;681.492,3409.955;Inherit;False;1;0;FLOAT;148;False;1;FLOAT;0
Node;AmplifyShaderEditor.RotateAboutAxisNode;1129;496.4512,2989.015;Inherit;False;False;4;0;FLOAT3;0,1,0;False;1;FLOAT;0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.BreakToComponentsNode;323;2896,4352;Inherit;False;FLOAT4;1;0;FLOAT4;0,0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.PiNode;321;2848,4512;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.ASinOpNode;319;3024,4368;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TauNode;325;3024,4304;Inherit;False;0;1;FLOAT;0
Node;AmplifyShaderEditor.RadiansOpNode;880;961.4919,3408.955;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RotateAboutAxisNode;1105;520.4919,3273.955;Inherit;False;True;4;0;FLOAT3;1,0,0;False;1;FLOAT;0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.CommentaryNode;433;2256,3664;Inherit;False;1178.901;409.7482;Comment;10;430;429;425;426;427;424;428;432;431;423;Get Skybox Light Distance;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;329;3024,4496;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;2;False;1;FLOAT;0
Node;AmplifyShaderEditor.ATan2OpNode;326;3024,4208;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;320;3152,4368;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RotateAboutAxisNode;878;803.4922,3272.955;Inherit;False;False;4;0;FLOAT3;0,1,0;False;1;FLOAT;0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.WorldSpaceLightDirHlpNode;426;2272,3872;Inherit;False;False;1;0;FLOAT;0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.WorldPosInputsNode;427;2272,3712;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleDivideOpNode;324;3152,4208;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;384;-2864,2528;Inherit;False;3046.742;1083.67;Comment;22;548;546;547;506;508;434;358;367;374;365;364;363;362;504;502;361;360;359;377;340;339;338;Sun;1,1,1,1;0;0
Node;AmplifyShaderEditor.DynamicAppendNode;318;3312,4208;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.NormalizeNode;424;2496,3712;Inherit;False;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.NormalizeNode;425;2496,3792;Inherit;False;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.PiNode;934;1181.492,3238.955;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.BreakToComponentsNode;926;1133.492,2998.955;Inherit;True;FLOAT3;1;0;FLOAT3;0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.ACosOpNode;932;1421.492,3142.955;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;338;-2848,2832;Inherit;False;1644;739;;19;375;366;356;352;351;350;349;348;347;346;345;344;343;342;341;379;436;514;512;Sunset Line Gradient;0,0,0,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;554;-4032,2784;Inherit;False;1120.464;3106.424;Comment;84;499;140;527;130;495;139;497;138;493;540;136;481;239;536;218;509;192;515;193;511;191;513;189;505;184;507;182;501;186;503;188;531;207;533;211;521;119;519;120;525;115;523;116;517;112;529;147;580;555;591;590;592;593;594;595;596;597;599;600;601;602;623;624;639;640;643;644;645;646;658;657;663;664;675;676;679;680;699;700;707;708;746;747;137;Variables;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;933;1341.492,3206.955;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;2;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;429;2640,3808;Inherit;False;Constant;_Vector0;Vector 0;0;0;Create;True;0;0;0;False;0;False;0,2;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.RegisterLocalVarNode;332;3440,4208;Inherit;True;SkyboxUV;-1;True;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DistanceOpNode;428;2640,3712;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;430;2640,3936;Inherit;False;Constant;_Vector1;Vector 1;0;0;Create;True;0;0;0;False;0;False;0,1;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.ATan2OpNode;927;1421.492,3046.955;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TauNode;935;1533.492,3142.955;Inherit;False;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;931;1453.492,3206.955;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;423;2896,3712;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;191;-3984,4560;Inherit;False;Property;_SunsetVerticalFalloff;Sunset Vertical Falloff;15;0;Create;True;0;0;0;False;0;False;0.4;0.114;0.01;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;379;-2830,3320;Inherit;False;332;SkyboxUV;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;189;-3984,4480;Inherit;False;Property;_SunsetHorizonFalloff;Sunset Horizon Falloff;14;0;Create;True;0;0;0;False;0;False;0.5;0.122;0.01;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;431;3072,3728;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;511;-3728,4560;Inherit;False;varSunsetVerticalFalloff;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.BreakToComponentsNode;352;-2656,3312;Inherit;False;FLOAT2;1;0;FLOAT2;0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.SimpleDivideOpNode;928;1645.492,3110.955;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;936;1565.492,3206.955;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;2;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;432;3200,3728;Inherit;False;GetSkyboxLightDistance;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.AbsOpNode;351;-2544,3328;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;512;-2672,3408;Inherit;False;511;varSunsetVerticalFalloff;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;1059;2157.492,3286.955;Inherit;False;Property;_ShowGalexy;Show Galexy;54;0;Create;True;0;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;513;-3728,4480;Inherit;False;varSunsetHorizonFalloff;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;930;1677.492,3206.955;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;1051;1869.492,3190.955;Inherit;True;Property;_Stars;Stars;53;1;[HDR];Create;True;0;0;0;False;0;False;-1;None;24928e6d82e968a40a3e2d8b0d8c24a4;True;0;False;black;LockedToTexture2D;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.OneMinusNode;1060;2413.492,3286.955;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;514;-2832,3216;Inherit;False;513;varSunsetHorizonFalloff;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;436;-2832,3136;Inherit;False;432;GetSkyboxLightDistance;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;375;-2416,3328;Inherit;False;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;1047;1869.492,2998.955;Inherit;True;Property;_starswithfurtherstars;stars with further stars;51;1;[HDR];Create;True;0;0;0;False;0;False;-1;None;5a77f4ee00e204946b5956918b744a50;True;0;False;black;LockedToTexture2D;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;1118;2525.492,3447.955;Inherit;False;Property;_FarStars;FarStars;56;0;Create;True;0;0;0;False;0;False;0;0.109;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;193;-3456,2832;Inherit;False;Property;_SunsetRadialFalloff;Sunset Radial Falloff;16;0;Create;True;0;0;0;False;0;False;0.2;0.048;0.01;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;515;-3200,2832;Inherit;False;varSunsetRadialFalloff;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;350;-2272,3328;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;348;-2576,3168;Inherit;False;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;339;-2016,2560;Inherit;False;816.1934;238;;5;373;372;371;435;516;Circle Gradient;0,0,0,1;0;0
Node;AmplifyShaderEditor.BlendOpsNode;1054;2557.492,3158.955;Inherit;True;Subtract;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0.3;False;1;COLOR;0
Node;AmplifyShaderEditor.OneMinusNode;1120;2797.492,3447.955;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WorldSpaceLightDirHlpNode;344;-2384,2928;Inherit;False;False;1;0;FLOAT;0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SmoothstepOpNode;346;-2112,3264;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;516;-2000,2688;Inherit;False;515;varSunsetRadialFalloff;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;347;-2352,3168;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;435;-1999,2615;Inherit;False;432;GetSkyboxLightDistance;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;1127;2966.513,3389.894;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.BreakToComponentsNode;343;-2144,2944;Inherit;False;FLOAT3;1;0;FLOAT3;0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;1119;2813.492,3254.955;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;1,1,1,0;False;1;COLOR;0
Node;AmplifyShaderEditor.BlendOpsNode;1116;2941.491,3174.955;Inherit;True;HardMix;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0.3;False;1;COLOR;0
Node;AmplifyShaderEditor.SmoothstepOpNode;341;-1936,3040;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;-0.2;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;345;-1936,3168;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;373;-1728,2640;Inherit;False;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;140;-3456,4544;Inherit;False;Property;_StarDaytimeBrightness;Star Daytime Brightness;25;0;Create;True;0;0;0;False;0;False;0.1;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.WorldSpaceLightDirHlpNode;987;2669.492,2998.955;Inherit;False;False;1;0;FLOAT;0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SmoothstepOpNode;342;-1936,2928;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0.5;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;1126;3165.513,3368.894;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.BreakToComponentsNode;986;2893.491,2998.955;Inherit;False;FLOAT3;1;0;FLOAT3;0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;356;-1760,2928;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;499;-3200,4544;Inherit;False;varStarDaytimeBrightness;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;182;-3984,4320;Inherit;False;Property;_SunSize;Sun Size;12;0;Create;True;0;0;0;False;0;False;0.004;0.066;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.BreakToComponentsNode;1121;3181.491,3174.955;Inherit;False;COLOR;1;0;COLOR;0,0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.OneMinusNode;372;-1568,2656;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;1125;3172.512,3310.894;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;349;-1792,3168;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;371;-1328,2688;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;184;-3984,4400;Inherit;False;Property;_SunFalloff;Sun Falloff;13;0;Create;True;0;0;0;False;0;False;2;3.9;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;507;-3728,4320;Inherit;False;varSunSize;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;366;-1536,3136;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;1124;3396.513,3277.894;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;984;3021.491,2998.955;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0.1;False;2;FLOAT;-0.4;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;1122;3293.491,3174.955;Inherit;False;FLOAT3;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;994;2893.491,3110.955;Inherit;False;499;varStarDaytimeBrightness;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;546;-1145,2816;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;340;-1120,3088;Inherit;False;865;430.1111;;6;370;369;368;510;535;549;Sunset Blend;0,0,0,1;0;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;505;-3856,4400;Inherit;False;varSunFalloff;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;186;-3984,4144;Inherit;False;Property;_SunHorizonColor;Sun Horizon Color;11;1;[HDR];Create;True;0;0;0;False;0;False;98.45185,43.81365,18.55637,0;98.45185,43.81365,18.55637,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DesaturateOpNode;1117;3421.491,3174.955;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT;1;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;1004;3213.491,3334.955;Inherit;False;Property;_StarBrightness;Star Brightness;50;0;Create;True;0;0;0;False;0;False;0;0.95;0;5;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;112;-3984,3024;Inherit;False;Property;_HorizonZenithColorBlend;Horizon / Zenith Color Blend;3;0;Create;True;0;0;0;False;0;False;0.1;0.22;0.1;2;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;192;-3456,2912;Inherit;False;Property;_SunsetIntensity;Sunset Intensity;17;0;Create;True;0;0;0;False;0;False;0.1;0.095;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;1068;2141.492,3446.955;Inherit;False;Property;_ShowConstilationMap;Show Constilation Map;55;0;Create;True;0;0;0;False;0;False;0;0.003;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;434;-1028,2869;Inherit;False;432;GetSkyboxLightDistance;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;547;-1177,3189;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;188;-3984,3968;Inherit;False;Property;_SunZenithColor;Sun Zenith Color;10;1;[HDR];Create;True;0;0;0;False;0;False;136.575,114.4084,61.4945,0;136.575,114.4084,61.4945,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TFHCRemapNode;988;3165.491,2998.955;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.WorldSpaceLightDirHlpNode;364;-1008,2720;Inherit;False;False;1;0;FLOAT;0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.GetLocalVarNode;508;-996,2956;Inherit;False;507;varSunSize;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;337;-210.753,1856.516;Inherit;False;332;SkyboxUV;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;1065;1869.492,3382.955;Inherit;True;Property;_ConstelationMap;Constelation Map;52;0;Create;True;0;0;0;False;0;False;-1;None;ec31f0e85b70bbb4092281a71f925701;True;0;False;white;LockedToTexture2D;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.WireNode;549;-1040,3232;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;115;-3984,3280;Inherit;False;Property;_DayZenithColor;Day Zenith Color;5;1;[HDR];Create;True;0;0;0;False;0;False;0.02745098,0.1764706,0.7450981,0;0.02745098,0.1764706,0.7450981,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;517;-3728,3024;Inherit;False;varHorizonZenithColorBlend;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;1067;2397.492,3382.955;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.PowerNode;358;-768,2880;Inherit;False;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;509;-3200,2912;Inherit;False;varSunsetIntensity;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;503;-3760,3968;Inherit;False;varSunZenithColor;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.CommentaryNode;216;1142.713,2112.56;Inherit;False;870;393;;9;214;213;212;210;206;209;334;532;534;Horizon Fog;0,0,0,1;0;0
Node;AmplifyShaderEditor.GetLocalVarNode;506;-784,2976;Inherit;False;505;varSunFalloff;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.BreakToComponentsNode;109;-34.75297,1824.516;Inherit;True;FLOAT2;1;0;FLOAT2;0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.RegisterLocalVarNode;501;-3760,4144;Inherit;False;varSunHorizonColor;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.WireNode;548;-1072,3040;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;1055;3581.491,3174.955;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.CommentaryNode;126;523.0093,2247.319;Inherit;False;519.2001;192.6;;3;122;123;124;Day/Night by Sun Position;0,0,0,1;0;0
Node;AmplifyShaderEditor.SaturateNode;992;3341.491,2998.955;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;120;-3984,3456;Inherit;False;Property;_NightHorizonColor;Night Horizon Color;6;1;[HDR];Create;True;0;0;0;False;0;False;0.08627451,0.07843138,0.1333333,0;0.02269492,0.02339347,0.05660379,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.BreakToComponentsNode;363;-800,2720;Inherit;False;FLOAT3;1;0;FLOAT3;0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.ColorNode;119;-3984,3632;Inherit;False;Property;_NightZenithColor;Night Zenith Color;7;1;[HDR];Create;True;0;0;0;False;0;False;0.1019608,0.01568628,0.1019608,0;0.003337495,0.003541257,0.009433985,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;116;-3984,3104;Inherit;False;Property;_DayHorizonColor;Day Horizon Color;4;1;[HDR];Create;True;0;0;0;False;0;False;0.3137255,0.4588235,0.8,0;0.3137255,0.4588235,0.8,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;510;-845,3340;Inherit;False;509;varSunsetIntensity;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;334;1254.713,2240.56;Inherit;False;332;SkyboxUV;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;525;-3792,3280;Inherit;False;varDayZenithColor;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.OneMinusNode;374;-624,2880;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMaxOpNode;367;-592,2960;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;113;637.2469,1936.516;Inherit;False;437;265;;3;526;114;524;Day Color;0,0,0,1;0;0
Node;AmplifyShaderEditor.GetLocalVarNode;518;93.24702,2064.516;Inherit;False;517;varHorizonZenithColorBlend;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;502;-736,2576;Inherit;False;501;varSunHorizonColor;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;211;-3984,3808;Inherit;False;Property;_HorizonDesaturatiotnFalloff;Horizon Desaturatiotn Falloff;8;0;Create;True;0;0;0;False;0;False;3;3.52;0;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;370;-800,3232;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;117;637.2469,1664.515;Inherit;False;436.4001;249.7;;3;118;520;522;Night Color;0,0,0,1;0;0
Node;AmplifyShaderEditor.WireNode;1128;3853.49,3318.955;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;521;-3792,3632;Inherit;False;varNightZenithColor;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SmoothstepOpNode;362;-688,2704;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0.1;False;2;FLOAT;0.3;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;523;-3792,3104;Inherit;False;varDayHorizonColor;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.WorldSpaceLightDirHlpNode;124;542.0092,2270.319;Inherit;False;False;1;0;FLOAT;0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleAddOpNode;1066;3757.491,3350.955;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SaturateNode;110;189.247,1840.516;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;519;-3792,3456;Inherit;False;varNightHorizonColor;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;504;-736,2640;Inherit;False;503;varSunZenithColor;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;207;-3984,3888;Inherit;False;Property;_HorizonSaturationAmount;Horizon Saturation Amount;9;0;Create;True;0;0;0;False;0;False;0.3;0.175;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;369;-608,3232;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;533;-3744,3808;Inherit;False;varHorizonDesaturatiotnFalloff;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;535;-736,3136;Inherit;False;501;varSunHorizonColor;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;361;-464,2576;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.BreakToComponentsNode;214;1414.713,2240.56;Inherit;False;FLOAT2;1;0;FLOAT2;0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.PowerNode;365;-464,2880;Inherit;False;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;520;653.2469,1712.516;Inherit;False;519;varNightHorizonColor;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;526;653.2469,2064.516;Inherit;False;525;varDayZenithColor;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;522;653.2469,1792.516;Inherit;False;521;varNightZenithColor;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.PowerNode;111;365.247,1840.516;Inherit;True;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.BreakToComponentsNode;123;747.0091,2284.319;Inherit;False;FLOAT3;1;0;FLOAT3;0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.GetLocalVarNode;524;653.2469,1984.516;Inherit;False;523;varDayHorizonColor;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;993;3901.491,3334.955;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;118;893.2469,1744.516;Inherit;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SmoothstepOpNode;122;879.0091,2284.319;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;-0.3;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;531;-3728,3888;Inherit;False;varHorizonSaturationAmount;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;360;-256,2576;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;114;925.2469,1984.516;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;368;-464,3136;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;421;4029.491,3334.955;Inherit;False;Stars;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;534;1382.713,2384.56;Inherit;False;533;varHorizonDesaturatiotnFalloff;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;147;-3984,2848;Inherit;False;Property;_GroundColor;Ground Color;2;0;Create;True;0;0;0;False;0;False;0,0,0,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SaturateNode;213;1526.713,2272.56;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;422;1691.247,1673.515;Inherit;False;421;Stars;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;121;1213.247,1744.516;Inherit;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;359;-128,2576;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.OneMinusNode;212;1654.713,2272.56;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;529;-3792,2848;Inherit;False;varGroundColor;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;336;1974.133,2514.011;Inherit;False;332;SkyboxUV;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;532;1414.713,2176.56;Inherit;False;531;varHorizonSaturationAmount;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;210;1670.713,2368.56;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;209;1830.713,2272.56;Inherit;False;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.BreakToComponentsNode;170;2136.359,2518.088;Inherit;False;FLOAT2;1;0;FLOAT2;0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.SimpleAddOpNode;127;1853.247,1739.516;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;377;-16,2576;Inherit;False;Sun;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.FunctionNode;206;1766.713,2144.56;Inherit;False;Saturation;-1;;207;4db44639008164f419218e9fd71501dd;0;2;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;530;2445.247,2000.516;Inherit;False;529;varGroundColor;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.SmoothstepOpNode;169;2254.359,2504.088;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;208;2109.359,2179.088;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;378;2067.359,2327.088;Inherit;False;377;Sun;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;969;2148.771,2423.675;Inherit;False;Property;_GroundAlpha;Ground Alpha;49;0;Create;True;0;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;454;-4091.636,1506.722;Inherit;False;2993.276;896.9688;Comment;34;577;296;537;290;439;445;446;443;438;444;447;263;448;538;262;275;484;301;302;276;440;299;258;278;260;270;266;269;539;272;264;256;255;257;Alpha;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;317;5343.74,2502.016;Inherit;False;5307.88;2748.396;Comment;32;453;308;309;1221;1222;1223;1224;1225;1226;1227;1228;1229;1230;1231;1232;1233;1234;1235;1236;1237;1238;1239;1240;1244;1245;1246;1247;1248;1249;1250;1251;1252;Clouds;1,1,1,1;0;0
Node;AmplifyShaderEditor.BreakToComponentsNode;152;2637.247,2000.516;Inherit;False;COLOR;1;0;COLOR;0,0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.CommentaryNode;255;-3051.462,1729.601;Inherit;False;546;136.3705;;4;289;286;288;486;Cloudiness;0,0,0,1;0;0
Node;AmplifyShaderEditor.DynamicAppendNode;153;2749.247,2000.516;Inherit;False;FLOAT3;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.CommentaryNode;576;-2800,5024;Inherit;False;925;640;Comment;11;559;557;560;558;561;565;564;563;562;581;582;WorldSpace UVs setup;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;615;-1826,5054;Inherit;False;1112.826;699.0771;Comment;10;620;608;606;607;613;614;603;605;610;604;Selection between textures and noises usage;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;253;-4888.569,1992.56;Inherit;False;637.3237;317.7527;;5;441;261;267;303;480;Scale;0,0,0,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;256;-3067.462,1873.601;Inherit;False;566;229;;5;287;291;300;488;450;Cloud Height Falloff;0,0,0,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;649;-754,6206;Inherit;False;1953.8;484.7002;Comment;11;650;625;648;647;641;642;638;637;626;629;684;Cloud detail noise setup;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;682;-639,5676;Inherit;False;2491.825;491.5869;Comment;16;665;666;671;674;678;677;673;672;670;662;653;652;651;622;621;618;Cloud Shape Setup;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;453;9183.741,2566.016;Inherit;False;1218;774;Comment;11;268;283;277;284;285;292;304;274;437;490;492;Color;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;661;-637,5281;Inherit;False;948.0513;334.8228;Comment;5;654;655;656;659;660;Outer mask setup;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleAddOpNode;143;2296.359,2191.088;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.CommentaryNode;257;-1819.462,1761.601;Inherit;False;239;209;;1;282;Cloud Edge;1,1,1,1;0;0
Node;AmplifyShaderEditor.LerpOp;968;2438.771,2434.675;Inherit;False;3;0;FLOAT;1.61;False;1;FLOAT;1;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;254;-4888.569,1560.561;Inherit;False;794.941;396.6914;;7;442;271;265;259;281;482;273;Wind;0,0,0,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;710;1234.224,4761.738;Inherit;False;1869;885.3667;Comment;15;706;688;690;692;695;697;698;701;702;694;689;691;696;705;709;Fake SubSurface Scattering;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;575;-2496,5856;Inherit;False;1703.081;545.0151;Comment;10;584;587;589;574;572;569;571;568;567;619;Cloud Height Correction;1,1,1,1;0;0
Node;AmplifyShaderEditor.SaturateNode;1229;6179.111,3498.556;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;1245;7771.207,3216.676;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0.02;False;1;FLOAT;0
Node;AmplifyShaderEditor.RotatorNode;1224;6284.784,2981.926;Inherit;True;3;0;FLOAT2;0,0;False;1;FLOAT2;0,0.1;False;2;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;1226;6540.784,2837.926;Inherit;True;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;1225;6188.784,2868.926;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0.1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;1238;7536,2848;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;1252;8762.708,3368.391;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;1247;8208,3072;Inherit;True;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;1246;7968,3216;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;12;False;1;FLOAT;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;1227;6764.784,2837.926;Inherit;True;Simplex2D;True;False;2;0;FLOAT2;0,0;False;1;FLOAT;200;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;1240;7636.583,3248.942;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;590;-3328,5184;Inherit;False;varcloudScale01;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WorldToObjectTransfNode;1241;7397.207,3672.676;Inherit;True;1;0;FLOAT4;0,0,0,1;False;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;675;-3856,4880;Inherit;False;varCloudsPower;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;1249;8432,3072;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0.8;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;1230;6348.784,3509.925;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;142;2172.247,1712.516;Inherit;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;445;-4059.461,2033.601;Inherit;False;442;cloudWind;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.ColorNode;1244;7856,2640;Inherit;False;Constant;_Color0;Color 0;62;0;Create;True;0;0;0;False;0;False;1,1,1,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;1237;7248,2832;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0.8;False;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;1228;7020.784,2837.926;Inherit;True;True;2;0;FLOAT;0;False;1;FLOAT;2;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;308;8064,2656;Inherit;True;CloudColor;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;309;8889,3396;Inherit;True;CloudAlpha;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;316;1949.247,1624.516;Inherit;False;309;CloudAlpha;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;447;-4059.461,2305.601;Inherit;False;442;cloudWind;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleTimeNode;1221;5985.784,3024.926;Inherit;False;1;0;FLOAT;0.01;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;315;1937.247,1544.516;Inherit;False;308;CloudColor;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;1233;6748.784,3317.925;Inherit;True;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.Vector2Node;1236;6812.784,3653.925;Inherit;False;Constant;_Vector4;Vector 4;1;0;Create;True;0;0;0;False;0;False;0,0;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;1232;6524.784,3413.925;Inherit;True;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DynamicAppendNode;1231;6188.784,3285.925;Inherit;True;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.WorldToObjectTransfNode;1222;5845.784,3352.425;Inherit;True;1;0;FLOAT4;0,0,0,1;False;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.WorldPosInputsNode;1223;5609.784,3348.425;Inherit;True;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SamplerNode;1239;7264,3236;Inherit;True;Property;_TextureSample3;Texture Sample 3;59;0;Create;True;0;0;0;False;0;False;-1;None;8acc449dfb500904eaa05c75ff220196;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;492;9391.741,3030.016;Inherit;False;-1;;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.SaturateNode;695;2132.224,4811.738;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;626;-464,6384;Inherit;True;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;259;-4712.569,1816.56;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;584;-2496,5904;Inherit;False;-1;;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.BreakToComponentsNode;1149;-2784.561,757.7444;Inherit;True;FLOAT3;1;0;FLOAT3;0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.RangedFloatNode;1158;-2432.561,1077.744;Inherit;False;Property;_NadirBlendPower;NadirBlendPower;58;0;Create;True;0;0;0;False;0;False;1.47;0.1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;645;-4016,5232;Inherit;False;Property;_DetailNoiseInfluence;DetailNoiseInfluence;35;0;Create;True;0;0;0;False;0;False;0.1057;0.1057;0;0.2;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;284;9711.741,2790.016;Inherit;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;278;-3163.462,1617.601;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;272;-3627.462,1585.601;Inherit;True;Property;_TextureSample0;Texture Sample 0;0;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Instance;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;653;449,5772;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;744;3861.241,6474.325;Inherit;True;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;561;-2288,5200;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;138;-3456,4304;Inherit;False;Property;_StarScale;Star Scale;22;0;Create;True;0;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;439;-4059.461,1873.601;Inherit;False;332;SkyboxUV;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleTimeNode;559;-2464,5184;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;536;-3248,2992;Inherit;False;varCloudTexture;-1;True;1;0;SAMPLER2D;;False;1;SAMPLER2D;0
Node;AmplifyShaderEditor.RangedFloatNode;137;-3481.58,4224.59;Inherit;False;Property;_StarHorizonFalloff;Star Horizon Falloff;21;0;Create;True;0;0;0;False;0;False;0.2;0.479;0.1;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;585;-4416,5441;Inherit;False;varCloudHeight;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;480;-4872.569,2072.56;Inherit;False;-1;;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;1167;-1578.507,549.5291;Inherit;False;Constant;_ZenithColor147;Zenith Color1.47;67;0;Create;True;0;0;0;False;0;False;0,0.8371129,1,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMaxOpNode;267;-4696.569,2088.56;Inherit;False;2;0;FLOAT;0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.FunctionNode;263;-3835.462,1937.601;Inherit;False;Tiling and Offset;0;;204;67871fda73c6c684a8d5ab68eae7587e;0;3;8;FLOAT2;0,0;False;9;FLOAT2;0,0;False;10;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;706;2340.224,5451.738;Inherit;False;707;varSunSpreadPower;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;601;-3312,5728;Inherit;False;varTex01Noise01b;-1;True;1;0;INT;0;False;1;INT;0
Node;AmplifyShaderEditor.TexturePropertyNode;218;-3456,2992;Inherit;True;Property;_CloudTexture;Cloud Texture;18;0;Create;True;0;0;0;False;0;False;None;8acc449dfb500904eaa05c75ff220196;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.PowerNode;1157;-2224.561,869.7439;Inherit;True;True;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;1166;-1376.561,1013.744;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;743;3601.241,6428.325;Inherit;True;2;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.PowerNode;697;2164.224,5099.738;Inherit;False;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;625;-704,6400;Inherit;False;624;varDetailNoiseTiling;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;580;-3792,5712;Inherit;False;varPanSpeed_XY_ZW;-1;True;1;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.FogAndAmbientColorsNode;735;2848,6384;Inherit;False;unity_AmbientSky;0;1;COLOR;0
Node;AmplifyShaderEditor.SaturateNode;654;176,5360;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WorldPosInputsNode;1242;7161.207,3668.676;Inherit;True;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.GetLocalVarNode;484;-2107.462,1841.601;Inherit;False;-1;;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.TexturePropertyNode;595;-3488,5536;Inherit;True;Property;_TexClouds02;TexClouds02;29;0;Create;True;0;0;0;False;0;False;None;None;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.TexturePropertyNode;639;-3488,4992;Inherit;True;Property;_TexDetailNoise;TexDetailNoise;27;0;Create;True;0;0;0;False;0;False;None;None;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;301;-2091.462,1617.601;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;741;3361.241,6614.325;Inherit;True;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.NormalizeNode;692;1700.224,5035.738;Inherit;False;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;268;9983.741,2614.016;Inherit;True;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;481;-3312,3184;Inherit;False;varWind;-1;True;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TexturePropertyNode;594;-3488,5344;Inherit;True;Property;_TexClouds01;TexClouds01;28;0;Create;True;0;0;0;False;0;False;None;None;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.GetLocalVarNode;528;1038.247,1476.515;Inherit;False;527;varStarDensity;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;1162;-1376.561,805.7444;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMaxOpNode;277;9663.741,2614.016;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;258;-3323.462,2177.601;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0.12;False;1;FLOAT;0
Node;AmplifyShaderEditor.BreakToComponentsNode;736;3072,6368;Inherit;False;COLOR;1;0;COLOR;0,0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.RangedFloatNode;623;-4016,5392;Inherit;False;Property;_DetailNoiseTiling;DetailNoiseTiling;34;0;Create;True;0;0;0;False;0;False;0.045;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;737;3168,6368;Inherit;False;FLOAT3;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.TexturePropertyNode;136;-3456,4032;Inherit;True;Property;_StarTexture;Star Texture;20;0;Create;True;0;0;0;False;0;False;None;None;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.RegisterLocalVarNode;624;-3840,5392;Inherit;False;varDetailNoiseTiling;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;290;-3835.462,1633.601;Inherit;False;Tiling and Offset;0;;203;67871fda73c6c684a8d5ab68eae7587e;0;3;8;FLOAT2;0,0;False;9;FLOAT2;0,0;False;10;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.StepOpNode;296;-1931.462,1617.601;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;647;672,6352;Inherit;True;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;643;-3824,5312;Inherit;False;varDetailNoiseContrast;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;745;3616.241,6679.325;Inherit;False;746;varAmbientInfluence;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;271;-4424.569,1608.561;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.WireNode;631;-1864.946,5254.423;Inherit;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;657;-3872,5152;Inherit;False;varOuterMask;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;602;-3312,5808;Inherit;False;varTex01Noise02b;-1;True;1;0;INT;0;False;1;INT;0
Node;AmplifyShaderEditor.GetLocalVarNode;448;-4059.461,2225.601;Inherit;False;441;cloudScale;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;486;-3035.462,1761.601;Inherit;False;-1;;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.TimeNode;281;-4872.569,1592.561;Inherit;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.PowerNode;677;1617,5772;Inherit;True;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;563;-2288,5344;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;610;-1152,5344;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;723;2912,5984;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;712;3360,5248;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT3;0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;644;-4017,5312;Inherit;False;Property;_DetailNoiseContrast;DetailNoiseContrast;36;0;Create;True;0;0;0;False;0;False;6;6;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;437;9199.741,2678.016;Inherit;False;432;GetSkyboxLightDistance;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;680;-3488,4896;Inherit;False;Property;_CloudContrast;CloudContrast;41;0;Create;True;0;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;540;-3204,4011;Inherit;False;varStarTexture;-1;True;1;0;SAMPLER2D;;False;1;SAMPLER2D;0
Node;AmplifyShaderEditor.RangedFloatNode;273;-4856.569,1864.56;Inherit;False;Constant;_Float0;Float 0;4;0;Create;True;0;0;0;False;0;False;0.01;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;618;-303,5756;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;674;1169,5996;Inherit;False;675;varCloudsPower;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;636;-1298.626,5783.383;Inherit;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SaturateNode;262;-2907.462,1617.601;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector4Node;663;-4016,4960;Inherit;False;Property;_CloudHardness;CloudHardness;39;0;Create;True;0;0;0;False;0;False;0.1,1.1,-0.23,1.85;0,0,0,0;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.FogAndAmbientColorsNode;738;2848,6480;Inherit;False;unity_AmbientGround;0;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMaxOpNode;1152;-2448.561,677.7444;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;591;-3488,5184;Inherit;False;Property;_cloudScale01;cloudScale01;30;0;Create;True;0;0;0;False;0;False;0.29;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;629;-240,6368;Inherit;True;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;538;-3835.462,1873.601;Inherit;False;536;varCloudTexture;1;0;OBJECT;;False;1;SAMPLER2D;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;592;-3328,5264;Inherit;False;varcloudScale02;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;696;2356.224,5083.738;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.BreakToComponentsNode;300;-2907.462,1905.601;Inherit;False;FLOAT2;1;0;FLOAT2;0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.SaturateNode;713;3584,5248;Inherit;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;446;-4059.461,1953.601;Inherit;False;441;cloudScale;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;650;896,6352;Inherit;False;CloudDetailNoiseSetup;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;619;-1152,5920;Inherit;False;CloudHeightCorrection;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;617;-1867.007,5485.214;Inherit;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;482;-4872.569,1768.56;Inherit;False;481;varWind;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TFHCRemapNode;304;9471.741,2774.016;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;4;FLOAT;0.2;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;269;-3627.462,1889.601;Inherit;True;Property;_TextureSample1;Texture Sample 1;0;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Instance;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;640;-3264,4992;Inherit;False;varTexDetailNoise;-1;True;1;0;SAMPLER2D;0;False;1;SAMPLER2D;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;620;-960,5344;Inherit;False;CloudTexNoiseSelection;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;1161;-1760.561,805.7444;Inherit;True;2;0;FLOAT;1;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;635;-1296.626,5818.383;Inherit;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMinOpNode;1160;-2592.561,773.7444;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;1251;8786.708,3079.391;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;557;-2432,5088;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;676;-4016,4880;Inherit;False;Property;_CloudsPower;CloudsPower;40;0;Create;True;0;0;0;False;0;False;4;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;527;-3200,4464;Inherit;False;varStarDensity;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;287;-2651.462,1921.601;Inherit;False;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;652;-79,5836;Inherit;False;650;CloudDetailNoiseSetup;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;1155;-2224.561,677.7444;Inherit;True;True;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;264;-3835.462,2193.601;Inherit;False;Tiling and Offset;0;;205;67871fda73c6c684a8d5ab68eae7587e;0;3;8;FLOAT2;0,0;False;9;FLOAT2;0,0;False;10;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;746;-3728,4704;Inherit;False;varAmbientInfluence;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;558;-2432,5248;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;716;2576,5984;Inherit;True;Property;_TextureSample6;Texture Sample 6;0;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;698;1920.224,5184.738;Inherit;False;700;varSunSpreadContrast;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;665;337,5996;Inherit;False;664;varCloudHardness;1;0;OBJECT;;False;1;FLOAT4;0
Node;AmplifyShaderEditor.GetLocalVarNode;587;-2272,6144;Inherit;False;-1;;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;630;-1885.946,5095.423;Inherit;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;497;-3328,4304;Inherit;False;varStarScale;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;1169;-1114.507,802.5291;Inherit;True;3;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.BreakToComponentsNode;582;-2656,5152;Inherit;False;FLOAT4;1;0;FLOAT4;0,0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.TFHCRemapNode;283;9775.741,2614.016;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0.5;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;709;2868.224,5243.738;Inherit;True;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.BreakToComponentsNode;289;-2619.462,1761.601;Inherit;False;FLOAT2;1;0;FLOAT2;0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.GetLocalVarNode;622;-591,5740;Inherit;False;620;CloudTexNoiseSelection;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;655;-32,5360;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;597;-3264,5344;Inherit;False;varTexClouds01;-1;True;1;0;SAMPLER2D;0;False;1;SAMPLER2D;0
Node;AmplifyShaderEditor.GetLocalVarNode;607;-1776,5536;Inherit;False;601;varTex01Noise01b;1;0;OBJECT;;False;1;INT;0
Node;AmplifyShaderEditor.GetLocalVarNode;722;1904,6224;Inherit;False;620;CloudTexNoiseSelection;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;286;-2731.462,1761.601;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;1;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.NegateNode;690;1684.224,4811.738;Inherit;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;130;-3456,4464;Inherit;False;Property;_StarDensity;Star Density;24;0;Create;True;0;0;0;False;0;False;1;27.7;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;621;-591,5820;Inherit;False;619;CloudHeightCorrection;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;260;-3339.462,1905.601;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0.25;False;1;FLOAT;0
Node;AmplifyShaderEditor.TexCoordVertexDataNode;730;2688,5808;Inherit;False;0;4;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.WireNode;633;-1870.946,5624.423;Inherit;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.WireNode;683;-778.1423,6321.738;Inherit;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.ColorNode;1168;-1565.507,1014.529;Inherit;False;Constant;_NadirColor;Nadir Color;67;0;Create;True;0;0;0;False;0;False;0.05281806,1,0,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;560;-2288,5120;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.WireNode;634;-789.9458,5810.423;Inherit;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;671;737,5948;Inherit;False;650;CloudDetailNoiseSetup;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;128;1381.247,1369.515;Inherit;True;2;2;0;FLOAT4;0,0,0,0;False;1;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.Vector4Node;555;-4016,5712;Inherit;False;Property;_PanSpeed_XY_ZW;PanSpeed_XY_ZW;26;0;Create;True;0;0;0;False;0;False;-0.08,0.05,-0.04,0.53;0,0,0,0;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.NormalizeNode;1148;-3008.561,757.7444;Inherit;True;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;493;-3200,4224;Inherit;False;varStarHorizonFalloff;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;701;2020.224,5099.738;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;705;2619.316,5393.105;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;742;2905.241,6666.325;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;659;-349,5329;Inherit;True;Property;_TextureSample5;Texture Sample 5;50;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;733;3312,6240;Inherit;True;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.WireNode;628;-2101.048,5754.89;Inherit;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.OneMinusNode;291;-2811.462,1921.601;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;129;1230.247,1460.515;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;572;-1552,5920;Inherit;True;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;442;-4280.569,1608.561;Inherit;False;cloudWind;-1;True;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;679;-3312,4896;Inherit;False;varCloudContrast;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;648;400,6576;Inherit;False;646;varDetailNoiseInfluence;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;651;177,5772;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TexturePropertyNode;718;2320,5968;Inherit;True;Global;TexCloudGradient;TexCloudGradient;45;0;Create;True;0;0;0;False;0;False;None;None;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.GetLocalVarNode;603;-1776,5296;Inherit;False;596;varTexClouds02;1;0;OBJECT;;False;1;SAMPLER2D;0
Node;AmplifyShaderEditor.DotProductOpNode;691;1924.224,4811.738;Inherit;True;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;684;-713.1423,6310.738;Inherit;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;139;-3510,4384;Inherit;False;Property;_StarSpeed;StarSpeed;23;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;1248;8238.708,3300.391;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;565;-2096,5440;Inherit;True;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.Vector2Node;303;-4840.569,2168.56;Inherit;False;Constant;_Vector2;Vector 2;4;0;Create;True;0;0;0;False;0;False;1,1;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;1165;-1376.561,597.7444;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;266;-3339.462,1617.601;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;440;-4059.461,2145.601;Inherit;False;332;SkyboxUV;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;441;-4472.569,2088.56;Inherit;False;cloudScale;-1;True;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.WorldPosInputsNode;1132;-3216.561,757.7444;Inherit;True;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.LerpOp;145;2632.359,2173.088;Inherit;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.FunctionNode;577;-1547.462,1601.601;Inherit;True;Branch;-1;;206;d9128c2803b51ac4cb5f928659bfc971;0;3;3;INT;0;False;1;FLOAT4;0,0,0,0;False;2;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.GetLocalVarNode;604;-1776,5216;Inherit;False;602;varTex01Noise02b;1;0;OBJECT;;False;1;INT;0
Node;AmplifyShaderEditor.ColorNode;1164;-1568.561,805.7444;Inherit;False;Constant;_HorizonColor;Horizon Color;67;0;Create;True;0;0;0;False;0;False;1,1,1,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.AbsOpNode;1250;8624,3072;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;700;-3824,4800;Inherit;False;varSunSpreadContrast;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;302;-2235.462,1617.601;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;285;9455.741,3110.016;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;-0.3;False;1;FLOAT;0
Node;AmplifyShaderEditor.IntNode;599;-3488,5728;Inherit;False;Property;_Tex01Noise01;Tex01/Noise01;32;0;Create;True;0;0;0;False;0;False;0;0;False;0;1;INT;0
Node;AmplifyShaderEditor.GetLocalVarNode;444;-4059.461,1745.601;Inherit;False;442;cloudWind;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;1154;-2448.561,869.7439;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;-1;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;581;-2768,5088;Inherit;False;580;varPanSpeed_XY_ZW;1;0;OBJECT;;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;664;-3808,4960;Inherit;False;varCloudHardness;-1;True;1;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SmoothstepOpNode;282;-1771.462,1809.601;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;719;2368,6240;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;539;-3835.462,2129.601;Inherit;False;536;varCloudTexture;1;0;OBJECT;;False;1;SAMPLER2D;0
Node;AmplifyShaderEditor.SamplerNode;637;0,6320;Inherit;True;Property;_TextureSample4;Texture Sample 4;44;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SaturateNode;681;1856,5776;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;673;1393,5772;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;605;-1776,5104;Inherit;False;592;varcloudScale02;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;488;-2939.462,2017.601;Inherit;False;-1;;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.BreakToComponentsNode;739;3099.241,6554.325;Inherit;False;COLOR;1;0;COLOR;0,0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.GetLocalVarNode;450;-3067.462,1921.601;Inherit;False;332;SkyboxUV;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.AbsOpNode;568;-2032,5920;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LightColorNode;689;2672,5216;Inherit;False;0;3;COLOR;0;FLOAT3;1;FLOAT;2
Node;AmplifyShaderEditor.FloorOpNode;261;-4584.569,2088.56;Inherit;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.WorldSpaceLightDirHlpNode;688;1444.224,4811.738;Inherit;True;False;1;0;FLOAT;0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SaturateNode;672;1201,5772;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;239;-3456,3184;Inherit;False;Property;_Wind;Wind;19;0;Create;True;0;0;0;False;0;False;-0.5,1;-0.5,1;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.WireNode;627;-792.4262,5830.523;Inherit;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DynamicAppendNode;265;-4664.569,1608.561;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;495;-3328,4384;Inherit;False;varStarSpeed;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;1235;6796.784,3525.925;Inherit;False;Constant;_Vector3;Vector 3;1;0;Create;True;0;0;0;False;0;False;0.3,0.3;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.GetLocalVarNode;721;1936,6304;Inherit;False;619;CloudHeightCorrection;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;569;-2080,6144;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;614;-1504,5456;Inherit;True;TexNoise;-1;;212;cc1ec1cb0cb0d0a49adbd46ca7b4b1e6;0;4;3;FLOAT;0;False;1;FLOAT2;1,1;False;10;INT;0;False;8;SAMPLER2D;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;699;-4016,4800;Inherit;False;Property;_SunSpreadContrast;SunSpreadContrast;42;0;Create;True;0;0;0;False;0;False;8;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;678;1425,5996;Inherit;False;679;varCloudContrast;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;646;-3760,5232;Inherit;False;varDetailNoiseInfluence;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;708;-3488,4800;Inherit;False;Property;_SunSpreadPower;SunSpreadPower;43;0;Create;True;0;0;0;False;0;False;15;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;606;-1776,5632;Inherit;False;597;varTexClouds01;1;0;OBJECT;;False;1;SAMPLER2D;0
Node;AmplifyShaderEditor.GetLocalVarNode;656;-256,5520;Inherit;False;657;varOuterMask;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;702;1876.224,5099.738;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WorldSpaceLightDirHlpNode;292;9199.741,3094.016;Inherit;False;False;1;0;FLOAT;0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.TFHCRemapNode;274;9471.741,2614.016;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;1;False;4;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;490;9391.741,2950.016;Inherit;False;-1;;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.WireNode;616;-1860.007,5191.214;Inherit;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;658;-4016,5152;Inherit;False;Property;_OuterMask;OuterMask;37;0;Create;True;0;0;0;False;0;False;10;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;613;-1520,5120;Inherit;True;TexNoise;-1;;210;cc1ec1cb0cb0d0a49adbd46ca7b4b1e6;0;4;3;FLOAT;0;False;1;FLOAT2;1,1;False;10;INT;0;False;8;SAMPLER2D;;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;1234;7068.784,3317.925;Inherit;False;Tiling and Offset;0;;5;67871fda73c6c684a8d5ab68eae7587e;0;3;8;FLOAT2;0,0;False;9;FLOAT2;0,0;False;10;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;564;-2080,5168;Inherit;True;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TexturePropertyNode;660;-589,5329;Inherit;True;Property;_Texture0;Texture 0;38;0;Create;True;0;0;0;False;0;False;None;None;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.SamplerNode;270;-3611.462,2161.601;Inherit;True;Property;_TextureSample2;Texture Sample 2;0;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Instance;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleDivideOpNode;571;-1808,5920;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;596;-3264,5536;Inherit;False;varTexClouds02;-1;True;1;0;SAMPLER2D;0;False;1;SAMPLER2D;0
Node;AmplifyShaderEditor.SimpleAddOpNode;670;977,5772;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;1159;-1968.561,805.7444;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;438;-4059.461,1585.601;Inherit;False;332;SkyboxUV;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.WireNode;632;-1850.946,5744.423;Inherit;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;1156;-2448.561,597.7444;Inherit;False;Property;_ZenithBlendPower;ZenithBlendPower;57;0;Create;True;0;0;0;False;0;False;1.47;0.55;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.IntNode;600;-3488,5808;Inherit;False;Property;_Tex02Noise02;Tex02/Noise02;33;0;Create;True;0;0;0;False;0;False;0;0;False;0;1;INT;0
Node;AmplifyShaderEditor.ObjSpaceViewDirHlpNode;694;1284.224,5036.738;Inherit;True;1;0;FLOAT4;0,0,0,1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.GetLocalVarNode;608;-1776,5440;Inherit;False;590;varcloudScale01;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;720;2170.807,6233.778;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;940;1117.988,1297.701;Inherit;False;-1;;1;0;OBJECT;;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;707;-3312,4800;Inherit;False;varSunSpreadPower;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WorldPosInputsNode;562;-2464,5344;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.GetLocalVarNode;642;112,6528;Inherit;False;643;varDetailNoiseContrast;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.Compare;275;-1707.462,1521.601;Inherit;False;0;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;299;-3035.462,1617.601;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;638;-208,6256;Inherit;False;640;varTexDetailNoise;1;0;OBJECT;;False;1;SAMPLER2D;0
Node;AmplifyShaderEditor.DynamicAppendNode;740;3200,6544;Inherit;False;FLOAT3;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;443;-4059.461,1665.601;Inherit;False;441;cloudScale;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;589;-1808,6144;Inherit;False;-1;;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;747;-3997.48,4713.007;Inherit;False;Property;_AmbientInfluence;AmbientInfluence;44;0;Create;True;0;0;0;False;0;False;0.19;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;574;-1328,5920;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;567;-2240,5920;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;711;3136,5248;Inherit;True;2;2;0;FLOAT3;0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.TFHCRemapNode;276;-2411.462,1617.601;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;662;753,5772;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;288;-2859.462,1761.601;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;641;400,6352;Inherit;True;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;537;-3851.462,1553.601;Inherit;False;536;varCloudTexture;1;0;OBJECT;;False;1;SAMPLER2D;0
Node;AmplifyShaderEditor.SimpleAddOpNode;939;1606.988,1336.701;Inherit;False;2;2;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RangedFloatNode;593;-3488,5264;Inherit;False;Property;_cloudScale02;cloudScale02;31;0;Create;True;0;0;0;False;0;False;-1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.BreakToComponentsNode;666;545,5996;Inherit;False;FLOAT;1;0;FLOAT4;0,0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;11;2923.757,1981.5;Float;False;True;-1;6;ASEMaterialInspector;0;0;Unlit;SenpaiVR/Skybox;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Translucent;0.5;True;True;0;False;Opaque;;Transparent;All;18;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;True;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;331;0;330;0
WireConnection;322;0;331;0
WireConnection;328;0;331;0
WireConnection;1107;0;877;0
WireConnection;768;0;832;0
WireConnection;1130;0;1131;0
WireConnection;327;0;328;0
WireConnection;1106;0;1107;0
WireConnection;1129;1;1130;0
WireConnection;1129;3;768;0
WireConnection;323;0;322;0
WireConnection;319;0;323;1
WireConnection;880;0;774;0
WireConnection;1105;1;1106;0
WireConnection;1105;3;1129;0
WireConnection;329;0;321;0
WireConnection;326;0;327;0
WireConnection;326;1;327;2
WireConnection;320;0;319;0
WireConnection;320;1;329;0
WireConnection;878;1;880;0
WireConnection;878;3;1105;0
WireConnection;324;0;326;0
WireConnection;324;1;325;0
WireConnection;318;0;324;0
WireConnection;318;1;320;0
WireConnection;424;0;427;0
WireConnection;425;0;426;0
WireConnection;926;0;878;0
WireConnection;932;0;926;1
WireConnection;933;0;934;0
WireConnection;332;0;318;0
WireConnection;428;0;424;0
WireConnection;428;1;425;0
WireConnection;927;0;926;0
WireConnection;927;1;926;2
WireConnection;931;0;932;0
WireConnection;931;1;933;0
WireConnection;423;0;428;0
WireConnection;423;1;429;1
WireConnection;423;2;429;2
WireConnection;423;3;430;1
WireConnection;423;4;430;2
WireConnection;431;0;423;0
WireConnection;511;0;191;0
WireConnection;352;0;379;0
WireConnection;928;0;927;0
WireConnection;928;1;935;0
WireConnection;936;0;931;0
WireConnection;432;0;431;0
WireConnection;351;0;352;1
WireConnection;513;0;189;0
WireConnection;930;0;928;0
WireConnection;930;1;936;0
WireConnection;1051;1;930;0
WireConnection;1060;0;1059;0
WireConnection;375;0;351;0
WireConnection;375;1;512;0
WireConnection;1047;1;930;0
WireConnection;515;0;193;0
WireConnection;350;0;375;0
WireConnection;348;0;436;0
WireConnection;348;1;514;0
WireConnection;1054;0;1047;0
WireConnection;1054;1;1051;0
WireConnection;1054;2;1060;0
WireConnection;1120;0;1118;0
WireConnection;346;0;350;0
WireConnection;346;1;348;0
WireConnection;347;0;348;0
WireConnection;1127;0;1120;0
WireConnection;343;0;344;0
WireConnection;1119;0;1054;0
WireConnection;1116;0;1054;0
WireConnection;1116;1;1119;0
WireConnection;1116;2;1120;0
WireConnection;341;0;343;1
WireConnection;345;0;347;0
WireConnection;345;1;346;0
WireConnection;373;0;435;0
WireConnection;373;1;516;0
WireConnection;342;0;343;1
WireConnection;1126;0;1127;0
WireConnection;986;0;987;0
WireConnection;356;0;342;0
WireConnection;356;1;341;0
WireConnection;499;0;140;0
WireConnection;1121;0;1116;0
WireConnection;372;0;373;0
WireConnection;1125;0;1126;0
WireConnection;349;0;345;0
WireConnection;371;0;372;0
WireConnection;371;1;356;0
WireConnection;507;0;182;0
WireConnection;366;0;356;0
WireConnection;366;1;349;0
WireConnection;1124;0;1125;0
WireConnection;984;0;986;1
WireConnection;1122;0;1121;0
WireConnection;1122;1;1121;1
WireConnection;1122;2;1121;2
WireConnection;546;0;371;0
WireConnection;505;0;184;0
WireConnection;1117;0;1122;0
WireConnection;1117;1;1124;0
WireConnection;547;0;366;0
WireConnection;988;0;984;0
WireConnection;988;3;994;0
WireConnection;1065;1;930;0
WireConnection;549;0;547;0
WireConnection;517;0;112;0
WireConnection;1067;0;1065;0
WireConnection;1067;1;1068;0
WireConnection;358;0;434;0
WireConnection;358;1;508;0
WireConnection;509;0;192;0
WireConnection;503;0;188;0
WireConnection;109;0;337;0
WireConnection;501;0;186;0
WireConnection;548;0;546;0
WireConnection;1055;0;1117;0
WireConnection;1055;1;1004;0
WireConnection;992;0;988;0
WireConnection;363;0;364;0
WireConnection;525;0;115;0
WireConnection;374;0;358;0
WireConnection;367;0;506;0
WireConnection;370;0;548;0
WireConnection;370;1;549;0
WireConnection;1128;0;992;0
WireConnection;521;0;119;0
WireConnection;362;0;363;1
WireConnection;523;0;116;0
WireConnection;1066;0;1055;0
WireConnection;1066;1;1067;0
WireConnection;110;0;109;1
WireConnection;519;0;120;0
WireConnection;369;0;370;0
WireConnection;369;1;510;0
WireConnection;533;0;211;0
WireConnection;361;0;502;0
WireConnection;361;1;504;0
WireConnection;361;2;362;0
WireConnection;214;0;334;0
WireConnection;365;0;374;0
WireConnection;365;1;367;0
WireConnection;111;0;110;0
WireConnection;111;1;518;0
WireConnection;123;0;124;0
WireConnection;993;0;1128;0
WireConnection;993;1;1066;0
WireConnection;118;0;520;0
WireConnection;118;1;522;0
WireConnection;118;2;111;0
WireConnection;122;0;123;1
WireConnection;531;0;207;0
WireConnection;360;0;361;0
WireConnection;360;1;365;0
WireConnection;114;0;524;0
WireConnection;114;1;526;0
WireConnection;114;2;111;0
WireConnection;368;0;535;0
WireConnection;368;1;369;0
WireConnection;421;0;993;0
WireConnection;213;0;214;1
WireConnection;121;0;118;0
WireConnection;121;1;114;0
WireConnection;121;2;122;0
WireConnection;359;0;360;0
WireConnection;359;1;368;0
WireConnection;212;0;213;0
WireConnection;529;0;147;0
WireConnection;210;0;534;0
WireConnection;210;1;534;0
WireConnection;209;0;212;0
WireConnection;209;1;210;0
WireConnection;170;0;336;0
WireConnection;127;0;422;0
WireConnection;127;1;121;0
WireConnection;377;0;359;0
WireConnection;206;1;121;0
WireConnection;206;2;532;0
WireConnection;169;0;170;1
WireConnection;208;0;127;0
WireConnection;208;1;206;0
WireConnection;208;2;209;0
WireConnection;152;0;530;0
WireConnection;153;0;152;0
WireConnection;153;1;152;1
WireConnection;153;2;152;2
WireConnection;143;0;208;0
WireConnection;143;1;378;0
WireConnection;968;0;969;0
WireConnection;968;2;169;0
WireConnection;1229;0;1222;2
WireConnection;1245;0;1240;0
WireConnection;1224;0;1234;0
WireConnection;1224;2;1221;0
WireConnection;1226;0;1224;0
WireConnection;1226;1;1225;0
WireConnection;1225;0;1221;0
WireConnection;1238;0;1237;0
WireConnection;1238;1;1239;1
WireConnection;1252;0;1251;0
WireConnection;1247;0;1246;0
WireConnection;1246;0;1245;0
WireConnection;1227;0;1226;0
WireConnection;1240;0;1238;0
WireConnection;1240;1;1241;2
WireConnection;590;0;591;0
WireConnection;1241;0;1242;0
WireConnection;675;0;676;0
WireConnection;1249;0;1247;0
WireConnection;1230;0;1229;0
WireConnection;142;0;127;0
WireConnection;142;1;315;0
WireConnection;142;2;316;0
WireConnection;1237;0;1228;0
WireConnection;1228;0;1227;0
WireConnection;1233;0;1231;0
WireConnection;1233;1;1232;0
WireConnection;1232;0;1231;0
WireConnection;1232;1;1230;0
WireConnection;1231;0;1222;1
WireConnection;1231;1;1222;3
WireConnection;1222;0;1223;0
WireConnection;1239;1;1234;0
WireConnection;695;0;691;0
WireConnection;626;0;683;0
WireConnection;626;1;625;0
WireConnection;259;0;482;0
WireConnection;259;1;273;0
WireConnection;1149;0;1148;0
WireConnection;284;0;490;0
WireConnection;284;1;492;0
WireConnection;284;2;285;0
WireConnection;278;0;266;0
WireConnection;278;1;260;0
WireConnection;272;0;537;0
WireConnection;272;1;290;0
WireConnection;653;0;651;0
WireConnection;653;1;654;0
WireConnection;744;0;743;0
WireConnection;744;1;745;0
WireConnection;561;0;559;0
WireConnection;561;1;558;0
WireConnection;536;0;218;0
WireConnection;267;0;480;0
WireConnection;267;1;303;0
WireConnection;263;8;439;0
WireConnection;263;9;446;0
WireConnection;263;10;445;0
WireConnection;601;0;599;0
WireConnection;1157;0;1154;0
WireConnection;1157;1;1158;0
WireConnection;1166;0;1168;0
WireConnection;1166;1;1157;0
WireConnection;743;0;733;0
WireConnection;743;1;741;0
WireConnection;697;0;701;0
WireConnection;697;1;698;0
WireConnection;580;0;555;0
WireConnection;654;0;655;0
WireConnection;301;0;302;0
WireConnection;301;1;287;0
WireConnection;741;0;740;0
WireConnection;741;1;742;0
WireConnection;692;0;694;0
WireConnection;268;0;283;0
WireConnection;268;1;284;0
WireConnection;481;0;239;0
WireConnection;1162;0;1164;0
WireConnection;1162;1;1161;0
WireConnection;277;0;274;0
WireConnection;277;1;304;0
WireConnection;258;0;270;1
WireConnection;736;0;735;0
WireConnection;737;0;736;0
WireConnection;737;1;736;1
WireConnection;737;2;736;2
WireConnection;624;0;623;0
WireConnection;290;8;438;0
WireConnection;290;9;443;0
WireConnection;290;10;444;0
WireConnection;296;1;301;0
WireConnection;647;0;641;0
WireConnection;647;1;648;0
WireConnection;643;0;644;0
WireConnection;271;0;265;0
WireConnection;271;1;259;0
WireConnection;631;0;630;0
WireConnection;657;0;658;0
WireConnection;602;0;600;0
WireConnection;677;0;673;0
WireConnection;677;1;678;0
WireConnection;563;0;562;1
WireConnection;563;1;562;3
WireConnection;610;0;613;0
WireConnection;610;1;614;0
WireConnection;723;0;716;0
WireConnection;723;1;730;2
WireConnection;712;0;711;0
WireConnection;712;1;744;0
WireConnection;540;0;136;0
WireConnection;618;0;622;0
WireConnection;618;1;621;0
WireConnection;636;0;632;0
WireConnection;262;0;299;0
WireConnection;1152;0;1149;1
WireConnection;629;0;684;0
WireConnection;629;1;626;0
WireConnection;592;0;593;0
WireConnection;696;0;695;0
WireConnection;696;1;697;0
WireConnection;300;0;450;0
WireConnection;713;0;712;0
WireConnection;650;0;647;0
WireConnection;619;0;574;0
WireConnection;617;0;565;0
WireConnection;304;0;437;0
WireConnection;269;0;538;0
WireConnection;269;1;263;0
WireConnection;640;0;639;0
WireConnection;620;0;610;0
WireConnection;1161;1;1159;0
WireConnection;635;0;628;0
WireConnection;1160;0;1149;1
WireConnection;1251;0;1250;0
WireConnection;557;0;582;0
WireConnection;557;1;582;1
WireConnection;527;0;130;0
WireConnection;287;0;291;0
WireConnection;287;1;488;0
WireConnection;1155;0;1152;0
WireConnection;1155;1;1156;0
WireConnection;264;8;440;0
WireConnection;264;9;448;0
WireConnection;264;10;447;0
WireConnection;746;0;747;0
WireConnection;558;0;582;2
WireConnection;558;1;582;3
WireConnection;716;0;718;0
WireConnection;716;1;719;0
WireConnection;630;0;560;0
WireConnection;497;0;138;0
WireConnection;1169;0;1165;0
WireConnection;1169;1;1162;0
WireConnection;1169;2;1166;0
WireConnection;582;0;581;0
WireConnection;283;0;277;0
WireConnection;709;0;689;1
WireConnection;709;1;705;0
WireConnection;289;0;286;0
WireConnection;655;0;659;1
WireConnection;655;1;656;0
WireConnection;597;0;594;0
WireConnection;286;0;288;0
WireConnection;690;0;688;0
WireConnection;260;0;269;1
WireConnection;633;0;631;0
WireConnection;683;0;627;0
WireConnection;560;0;557;0
WireConnection;560;1;559;0
WireConnection;634;0;636;0
WireConnection;128;0;940;0
WireConnection;128;1;129;0
WireConnection;1148;0;1132;0
WireConnection;493;0;137;0
WireConnection;701;0;702;0
WireConnection;705;0;696;0
WireConnection;705;1;706;0
WireConnection;742;0;719;0
WireConnection;659;0;660;0
WireConnection;733;0;737;0
WireConnection;733;1;719;0
WireConnection;628;0;563;0
WireConnection;291;0;300;1
WireConnection;129;0;528;0
WireConnection;572;0;571;0
WireConnection;572;1;589;0
WireConnection;442;0;271;0
WireConnection;679;0;680;0
WireConnection;651;0;618;0
WireConnection;651;1;652;0
WireConnection;691;0;690;0
WireConnection;691;1;692;0
WireConnection;684;0;634;0
WireConnection;1248;0;1246;0
WireConnection;565;0;560;0
WireConnection;565;1;563;0
WireConnection;1165;0;1167;0
WireConnection;1165;1;1155;0
WireConnection;266;0;272;1
WireConnection;441;0;261;0
WireConnection;145;0;153;0
WireConnection;145;1;143;0
WireConnection;145;2;968;0
WireConnection;577;3;275;0
WireConnection;577;1;296;0
WireConnection;577;2;282;0
WireConnection;1250;0;1249;0
WireConnection;700;0;699;0
WireConnection;302;0;276;0
WireConnection;285;0;292;2
WireConnection;1154;0;1160;0
WireConnection;664;0;663;0
WireConnection;282;2;484;0
WireConnection;719;1;720;0
WireConnection;637;0;638;0
WireConnection;637;1;629;0
WireConnection;681;0;677;0
WireConnection;673;0;672;0
WireConnection;673;1;674;0
WireConnection;739;0;738;0
WireConnection;568;0;567;0
WireConnection;261;0;267;0
WireConnection;672;0;670;0
WireConnection;627;0;635;0
WireConnection;265;0;281;2
WireConnection;265;1;281;2
WireConnection;495;0;139;0
WireConnection;569;0;587;0
WireConnection;614;3;608;0
WireConnection;614;1;617;0
WireConnection;614;10;607;0
WireConnection;614;8;606;0
WireConnection;646;0;645;0
WireConnection;702;0;677;0
WireConnection;274;0;437;0
WireConnection;616;0;564;0
WireConnection;613;3;605;0
WireConnection;613;1;616;0
WireConnection;613;10;604;0
WireConnection;613;8;603;0
WireConnection;1234;8;1233;0
WireConnection;1234;9;1235;0
WireConnection;1234;10;1236;0
WireConnection;564;0;561;0
WireConnection;564;1;563;0
WireConnection;270;0;539;0
WireConnection;270;1;264;0
WireConnection;571;0;568;0
WireConnection;571;1;569;0
WireConnection;596;0;595;0
WireConnection;670;0;662;0
WireConnection;670;1;671;0
WireConnection;1159;0;1155;0
WireConnection;1159;1;1157;0
WireConnection;632;0;633;0
WireConnection;720;0;722;0
WireConnection;720;1;721;0
WireConnection;707;0;708;0
WireConnection;275;0;484;0
WireConnection;299;0;278;0
WireConnection;299;1;258;0
WireConnection;740;0;739;0
WireConnection;740;1;739;1
WireConnection;740;2;739;2
WireConnection;574;0;572;0
WireConnection;567;0;584;0
WireConnection;567;1;562;2
WireConnection;711;0;709;0
WireConnection;711;1;723;0
WireConnection;276;0;262;0
WireConnection;276;1;289;0
WireConnection;276;2;289;1
WireConnection;662;0;653;0
WireConnection;662;1;666;0
WireConnection;288;0;486;0
WireConnection;641;0;637;1
WireConnection;641;1;642;0
WireConnection;939;1;128;0
WireConnection;666;0;665;0
WireConnection;11;2;145;0
ASEEND*/
//CHKSM=0C2C8CE030DDBB72CAEB7A2AF560991DE7D4DFC3