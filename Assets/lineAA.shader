// Made with Amplify Shader Editor v1.9.1.5
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "lineAA"
{
	Properties
	{
		_TextureSample0("Texture Sample 0", 2D) = "black" {}
		_LineWidth("LineWidth", Range( 1 , 10)) = 1
		_LineColor("LineColor", Color) = (0,0,0,0)
		_GridSize("GridSize", Range( 0 , 100)) = 1

	}
	
	SubShader
	{
		
		
		Tags { "RenderType"="Opaque" }
	LOD 100

		CGINCLUDE
		#pragma target 3.0
		ENDCG
		Blend Off
		AlphaToMask Off
		Cull Back
		ColorMask RGBA
		ZWrite On
		ZTest LEqual
		Offset 0 , 0
		
		
		
		Pass
		{
			Name "Unlit"

			CGPROGRAM

			

			#ifndef UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX
			//only defining to not throw compilation error over Unity 5.5
			#define UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX(input)
			#endif
			#pragma vertex vert
			#pragma fragment frag
			#pragma multi_compile_instancing
			#include "UnityCG.cginc"
			#define ASE_NEEDS_FRAG_WORLD_POSITION


			struct appdata
			{
				float4 vertex : POSITION;
				float4 color : COLOR;
				float4 ase_texcoord : TEXCOORD0;
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};
			
			struct v2f
			{
				float4 vertex : SV_POSITION;
				#ifdef ASE_NEEDS_FRAG_WORLD_POSITION
				float3 worldPos : TEXCOORD0;
				#endif
				float4 ase_texcoord1 : TEXCOORD1;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};

			uniform sampler2D _TextureSample0;
			uniform float4 _LineColor;
			uniform float _LineWidth;
			uniform float _GridSize;

			
			v2f vert ( appdata v )
			{
				v2f o;
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);
				UNITY_TRANSFER_INSTANCE_ID(v, o);

				o.ase_texcoord1.xy = v.ase_texcoord.xy;
				
				//setting value to unused interpolator channels and avoid initialization warnings
				o.ase_texcoord1.zw = 0;
				float3 vertexValue = float3(0, 0, 0);
				#if ASE_ABSOLUTE_VERTEX_POS
				vertexValue = v.vertex.xyz;
				#endif
				vertexValue = vertexValue;
				#if ASE_ABSOLUTE_VERTEX_POS
				v.vertex.xyz = vertexValue;
				#else
				v.vertex.xyz += vertexValue;
				#endif
				o.vertex = UnityObjectToClipPos(v.vertex);

				#ifdef ASE_NEEDS_FRAG_WORLD_POSITION
				o.worldPos = mul(unity_ObjectToWorld, v.vertex).xyz;
				#endif
				return o;
			}
			
			fixed4 frag (v2f i ) : SV_Target
			{
				UNITY_SETUP_INSTANCE_ID(i);
				UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX(i);
				fixed4 finalColor;
				#ifdef ASE_NEEDS_FRAG_WORLD_POSITION
				float3 WorldPosition = i.worldPos;
				#endif
				float temp_output_43_0 = ( WorldPosition.x / _GridSize );
				float temp_output_6_0 = ( 1.0 / fwidth( temp_output_43_0 ) );
				float temp_output_12_0 = ( temp_output_6_0 * frac( temp_output_43_0 ) );
				float smoothstepResult66 = smoothstep( ( _LineWidth - 1.0 ) , _LineWidth , temp_output_12_0);
				float temp_output_82_0 = ( temp_output_6_0 - _LineWidth );
				float smoothstepResult65 = smoothstep( temp_output_82_0 , ( temp_output_82_0 + 1.0 ) , temp_output_12_0);
				float temp_output_42_0 = ( WorldPosition.y / _GridSize );
				float temp_output_24_0 = ( 1.0 / fwidth( temp_output_42_0 ) );
				float temp_output_25_0 = ( temp_output_24_0 * frac( temp_output_42_0 ) );
				float smoothstepResult50 = smoothstep( ( _LineWidth - 1.0 ) , _LineWidth , temp_output_25_0);
				float temp_output_81_0 = ( temp_output_24_0 - _LineWidth );
				float smoothstepResult57 = smoothstep( temp_output_81_0 , ( temp_output_81_0 + 1.0 ) , temp_output_25_0);
				float4 lerpResult46 = lerp( tex2D( _TextureSample0, i.ase_texcoord1.xy ) , _LineColor , ( 1.0 - ( ( smoothstepResult66 - smoothstepResult65 ) * ( smoothstepResult50 - smoothstepResult57 ) ) ));
				
				
				finalColor = lerpResult46;
				return finalColor;
			}
			ENDCG
		}
	}
	CustomEditor "ASEMaterialInspector"
	
	Fallback Off
}
/*ASEBEGIN
Version=19105
Node;AmplifyShaderEditor.SimpleDivideOpNode;6;-318.3199,82.34225;Inherit;False;2;0;FLOAT;1;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FractNode;18;-521.4783,313.3119;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DdxOpNode;1;-509.2936,60.80076;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;4;-552.2585,-145.3744;Inherit;True;Property;_TextureSample0;Texture Sample 0;0;0;Create;True;0;0;0;False;0;False;-1;None;5b4aaa060f5e2d347aa5e5f028f3beb7;True;0;False;black;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TexCoordVertexDataNode;2;-890.9881,22.763;Inherit;False;0;2;0;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleDivideOpNode;43;-898.0217,216.851;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FWidthOpNode;47;-523.551,177.6177;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;46;859.7193,121.2721;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;0;1069.078,21.10917;Float;False;True;-1;2;ASEMaterialInspector;100;5;lineAA;0770190933193b94aaa3065e307002fa;True;Unlit;0;0;Unlit;2;False;True;0;1;False;;0;False;;0;1;False;;0;False;;True;0;False;;0;False;;False;False;False;False;False;False;False;False;False;True;0;False;;False;True;0;False;;False;True;True;True;True;True;0;False;;False;False;False;False;False;False;False;True;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;True;1;False;;True;3;False;;True;True;0;False;;0;False;;True;1;RenderType=Opaque=RenderType;True;2;False;0;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;0;;0;0;Standard;1;Vertex Position,InvertActionOnDeselection;1;0;0;1;True;False;;False;0
Node;AmplifyShaderEditor.SmoothstepOpNode;66;303.6292,186.4504;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;24;-386.4313,902.4421;Inherit;False;2;0;FLOAT;1;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DdyOpNode;28;-598.276,892.5112;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FractNode;26;-608.7893,983.0126;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;57;251.2893,1165.247;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.FWidthOpNode;48;-597.9102,796.6553;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;25;-261.5745,903.553;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;12;-190.6829,82.83252;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;62;607.6902,730.1293;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;68;561.2413,385.5576;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;42;-922.2933,878.6105;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WorldPosInputsNode;14;-1616.209,287.1665;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.TexCoordVertexDataNode;77;-1741.151,538.864;Inherit;False;0;2;0;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SmoothstepOpNode;65;309.5944,358.8763;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;50;278.2473,932.243;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;59;132.2184,1267.4;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;52;127.7161,1007.604;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;67;130.4339,222.574;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;63;190.777,498.1663;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;81;-80.47015,1127.017;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;82;-8.898097,409.8427;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;84;760.7174,426.4418;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;69;661.692,539.325;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;86;-1138.238,417.8601;Inherit;False;Property;_GridSize;GridSize;3;0;Create;True;0;0;0;False;0;False;1;0;0;100;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;44;535.2302,151.5688;Inherit;False;Property;_LineColor;LineColor;2;0;Create;True;0;0;0;False;0;False;0,0,0,0;0.5566038,0.2179156,0.2179156,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;7;-638.7851,529.0718;Inherit;False;Property;_LineWidth;LineWidth;1;0;Create;True;0;0;0;False;0;False;1;1;1;10;0;1;FLOAT;0
WireConnection;6;1;47;0
WireConnection;18;0;43;0
WireConnection;1;0;43;0
WireConnection;4;1;2;0
WireConnection;43;0;14;1
WireConnection;43;1;86;0
WireConnection;47;0;43;0
WireConnection;46;0;4;0
WireConnection;46;1;44;0
WireConnection;46;2;84;0
WireConnection;0;0;46;0
WireConnection;66;0;12;0
WireConnection;66;1;67;0
WireConnection;66;2;7;0
WireConnection;24;1;48;0
WireConnection;28;0;42;0
WireConnection;26;0;42;0
WireConnection;57;0;25;0
WireConnection;57;1;81;0
WireConnection;57;2;59;0
WireConnection;48;0;42;0
WireConnection;25;0;24;0
WireConnection;25;1;26;0
WireConnection;12;0;6;0
WireConnection;12;1;18;0
WireConnection;62;0;50;0
WireConnection;62;1;57;0
WireConnection;68;0;66;0
WireConnection;68;1;65;0
WireConnection;42;0;14;2
WireConnection;42;1;86;0
WireConnection;65;0;12;0
WireConnection;65;1;82;0
WireConnection;65;2;63;0
WireConnection;50;0;25;0
WireConnection;50;1;52;0
WireConnection;50;2;7;0
WireConnection;59;0;81;0
WireConnection;52;0;7;0
WireConnection;67;0;7;0
WireConnection;63;0;82;0
WireConnection;81;0;24;0
WireConnection;81;1;7;0
WireConnection;82;0;6;0
WireConnection;82;1;7;0
WireConnection;84;0;69;0
WireConnection;69;0;68;0
WireConnection;69;1;62;0
ASEEND*/
//CHKSM=352C88ECB00D27F5AFBF12E864F744FE353BD6F4