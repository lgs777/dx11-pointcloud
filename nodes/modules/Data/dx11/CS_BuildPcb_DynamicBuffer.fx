float4x4 tW : WORLD;

int elementcount;
StructuredBuffer<float3> posBuffer <string uiname="Position Buffer";>;
StructuredBuffer<float4> colBuffer <string uiname="Color Buffer";>;

struct pointData
{
	float4 pos;
	float4 col;
	int groupId;
};
AppendStructuredBuffer<pointData> pcBuffer : BACKBUFFER;

//==============================================================================
//COMPUTE SHADER ===============================================================
//==============================================================================

[numthreads(64, 1, 1)]
void CSBuildPointcloudBuffer( uint3 DTid : SV_DispatchThreadID )
{
	
	if(DTid.x >= asuint(elementcount)){return;}
	
	float4 pos = float4(posBuffer[DTid.x],1);
	pos = mul(pos, tW);
	float4 col = colBuffer[DTid.x];

	pointData pd = {pos, col, 0};
	pcBuffer.Append(pd);
}

//==============================================================================
//TECHNIQUES ===================================================================
//==============================================================================

technique11 BuildPointcloudBuffer
{
	pass P0
	{
		SetComputeShader( CompileShader( cs_5_0, CSBuildPointcloudBuffer() ) );
	}
}