Shader "Custom/Surface/Transparent"
{
    Properties
    {
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
        _TransparencyTex("Transparency", 2D) = "white" {}
    }
    SubShader
    {
        Tags
        {
            "Queue" = "Transparent"
            "IgnoreProjector" = "True"
            "RenderType" = "Transparent"
        }
        LOD 200

        CGPROGRAM
        // Physically based Standard lighting model, blending with drawn objects
        #pragma surface surf Standard alpha:fade nolightmap

        #pragma target 3.0

        struct Input
        {
            float2 uv_MainTex;
        };

        sampler2D _MainTex;
        sampler2D _TransparencyTex;	

        // Add instancing support for this shader. You need to check 'Enable Instancing' on materials that use the shader.
        // See https://docs.unity3d.com/Manual/GPUInstancing.html for more information about instancing.
        // #pragma instancing_options assumeuniformscaling
        UNITY_INSTANCING_BUFFER_START(Props)
 
        UNITY_INSTANCING_BUFFER_END(Props)

        void surf (Input IN, inout SurfaceOutputStandard o)
        {
            fixed4 transparency = tex2D(_TransparencyTex, IN.uv_MainTex);
            fixed4 color = tex2D(_MainTex, IN.uv_MainTex);

            o.Alpha = DecodeFloatRGBA(transparency);
            o.Albedo = color.rgb;            
        }
        ENDCG
    }
    FallBack "Diffuse"
}
