// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "SenpaiVR/Raymarch"
{
	Properties
	{
		_Center("Center", Vector) = (0,0,0,0)
		_Radius("Radius", Float) = 0
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" "IsEmissive" = "true"  }
		Cull Back
		CGPROGRAM
		#pragma target 3.0
		#define STEPS 64
		#define STEP_SIZE 0.01
		#pragma surface surf Unlit keepalpha addshadow fullforwardshadows 
		struct Input
		{
			float3 worldPos;
		};

		uniform float3 _Center;
		uniform float _Radius;


		int RaymarchHit236( float3 position, float3 direction, float3 Center, float Radius, float Distance )
		{
			for (int i = 0; i < STEPS; i++)
			{
				if (Distance < Radius)
					return 1;
				position += direction * STEP_SIZE;
			}
			return 0;
		}


		float4 RaymarchHit248( int raycastHit )
		{
			float4 color1 = float4 (1,0,0,1);
			float4 color2 = float4 (1,1,1,1);
			if (raycastHit = 1) return color1;
			else return color2;
		}


		inline half4 LightingUnlit( SurfaceOutput s, half3 lightDir, half atten )
		{
			return half4 ( 0, 0, 0, s.Alpha );
		}

		void surf( Input i , inout SurfaceOutput o )
		{
			float3 ase_worldPos = i.worldPos;
			float3 position236 = ase_worldPos;
			float3 ase_worldViewDir = Unity_SafeNormalize( UnityWorldSpaceViewDir( ase_worldPos ) );
			float3 direction236 = ase_worldViewDir;
			float3 Center236 = _Center;
			float Radius236 = _Radius;
			float Distance236 = distance( ase_worldPos , _Center );
			int localRaymarchHit236 = RaymarchHit236( position236 , direction236 , Center236 , Radius236 , Distance236 );
			int raycastHit248 = localRaymarchHit236;
			float4 localRaymarchHit248 = RaymarchHit248( raycastHit248 );
			o.Emission = localRaymarchHit248.xyz;
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18935
2693;254;1290;303;-1570.432;-308.6343;1;True;True
Node;AmplifyShaderEditor.WorldPosInputsNode;245;1920,544;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.Vector3Node;241;1920,400;Inherit;False;Property;_Center;Center;0;0;Create;True;0;0;0;False;0;False;0,0,0;0,0,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.DistanceOpNode;244;2176,512;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;242;2176,448;Inherit;False;Property;_Radius;Radius;1;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ViewDirInputsCoordNode;240;1920,256;Inherit;False;World;True;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.WorldPosInputsNode;249;2001.076,107.9451;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.CommentaryNode;235;2770.524,283.6452;Inherit;False;277;209;Final Color;1;248;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CustomExpressionNode;236;2464,256;Inherit;False;for (int i = 0@ i < STEPS@ i++)${$	if (Distance < Radius)$		return 1@$	position += direction * STEP_SIZE@$}$return 0@;0;Create;5;True;position;FLOAT3;0,0,0;In;;Inherit;False;True;direction;FLOAT3;0,0,0;In;;Inherit;False;True;Center;FLOAT3;0,0,0;In;;Inherit;False;True;Radius;FLOAT;0;In;;Inherit;False;True;Distance;FLOAT;0;In;;Inherit;False;RaymarchHit;True;False;0;;False;5;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;1;INT;0
Node;AmplifyShaderEditor.CustomExpressionNode;248;2831.076,330.9451;Inherit;False;float4 color1 = float4 (1,0,0,1)@$float4 color2 = float4 (1,1,1,1)@$$if (raycastHit = 1) return color1@$else return color2@;4;Create;1;True;raycastHit;INT;0;In;;Inherit;False;RaymarchHit;True;False;0;;False;1;0;INT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;3142.629,282.227;Float;False;True;-1;2;ASEMaterialInspector;0;0;Unlit;SenpaiVR/Raymarch;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;18;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;True;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;2;Define;STEPS 64;False;;Custom;Define;STEP_SIZE 0.01;False;;Custom;0;0;False;0.1;False;-1;0;False;-1;False;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;244;0;245;0
WireConnection;244;1;241;0
WireConnection;236;0;249;0
WireConnection;236;1;240;0
WireConnection;236;2;241;0
WireConnection;236;3;242;0
WireConnection;236;4;244;0
WireConnection;248;0;236;0
WireConnection;0;2;248;0
ASEEND*/
//CHKSM=858CF1ABFA8A121D5CD5DC822A954D28E3E74A29