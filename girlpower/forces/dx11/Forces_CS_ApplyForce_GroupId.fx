#include "_PointData.fxh"
RWStructuredBuffer<pointData> rwPcBufferOut : BACKBUFFER;

#include "_ForceData.fxh"
StructuredBuffer<forceData> rwForceBufferIn;

int groupId = -1;
bool Apply;

[numthreads(64, 1, 1)]
void CS_Apply( uint3 i : SV_DispatchThreadID)
{
	uint cnt, stride;
	rwPcBufferOut.GetDimensions(cnt,stride);
	if (i.x >= cnt) { return; }
	
	if(Apply){
		pointData pd = rwPcBufferOut[i.x];
		if ( groupId == -1 || pd.groupId == groupId){
			forceData fd = rwForceBufferIn[i.x];			
			pd.pos += fd.velocity;
			//pd.pos += float3(0,0.1,0);
			rwPcBufferOut[i.x] = pd;
		}
	}
	
}

technique11 ApplyForce
{
	pass P0
	{
		SetComputeShader( CompileShader( cs_5_0, CS_Apply() ) );
	}
}
