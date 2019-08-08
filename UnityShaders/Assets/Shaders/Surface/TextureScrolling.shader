Shader "Custom/Surface/TextureScrolling"
{
    Properties
    {
        _Color ("Color", Color) = (1,1,1,1)
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
        _ScrollXSpeed("X scroll speed", Range(0, 10)) = 1
        _ScrollYSpeed("Y scroll speed", Range(0, 10)) = 1
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 200

        CGPROGRAM
        // Physically based Standard lighting model, and enable shadows on all light types
        #pragma surface surf Lambert fullforwardshadows

         
        #pragma target 3.0

        struct Input
        {
            float2 uv_MainTex;
        };
        
        fixed4 _Color;
        sampler2D _MainTex;
        fixed _ScrollXSpeed;
        fixed _ScrollYSpeed;

        // Add instancing support for this shader. You need to check 'Enable Instancing' on materials that use the shader.
        // See https://docs.unity3d.com/Manual/GPUInstancing.html for more information about instancing.
        // #pragma instancing_options assumeuniformscaling
        UNITY_INSTANCING_BUFFER_START(Props)
 
        UNITY_INSTANCING_BUFFER_END(Props)

        void surf (Input IN, inout SurfaceOutput o)
        {
            fixed2 scrolledUV = IN.uv_MainTex;

            // uv scaled values
            fixed xScroll = _ScrollXSpeed * _Time;
            fixed yScroll = _ScrollYSpeed * _Time;

            // Apply uv offset
            scrolledUV += fixed2(xScroll, yScroll);

            fixed4 c = tex2D (_MainTex, scrolledUV) * _Color;

            o.Albedo = c.rgb;
            o.Alpha = c.a;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
