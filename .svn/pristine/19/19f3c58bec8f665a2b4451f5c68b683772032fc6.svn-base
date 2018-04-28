package smart.graze.utils;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStreamReader;
import java.util.ArrayList;
import java.util.List;

import com.fasterxml.jackson.databind.ObjectMapper;

import smart.graze.core.AiasInfo;
import smart.graze.core.AiasPoint;
import smart.graze.core.EFInfo;
import smart.graze.core.EFPoint;
import smart.graze.core.ZoneGeometry;


public class EFDSOutput {
	public static void main(String[] args) throws IOException {
		readAndWrite();
	}
	
	
	public static void readAndWrite() throws IOException {
		//输入流
		FileInputStream fis = new FileInputStream("g:\\Point.txt");
		InputStreamReader isr = new InputStreamReader(fis);
		BufferedReader br = new BufferedReader(isr);
		
		//输出流，分别输出到存放电子围栏点坐标信息的文件和存放围栏内点集坐标信息的文件
		FileOutputStream efFos = new FileOutputStream (new File("g:\\efPoint.txt"),true ) ;
		FileOutputStream aiasFos = new FileOutputStream (new File("g:\\aiasPoint.txt"),true ) ;
		
		//围栏点
		EFPoint efPoint = null;
		//围栏点集
		ZoneGeometry zoneGeometry = null;
		//围栏点集信息
		EFInfo efInfo = null;
		
		//牲畜点
		AiasPoint aiasPoint = null;
		//牲畜点集信息
		AiasInfo aiasInfo = null;
		
		List<EFInfo> efInfoList = new ArrayList<>();
		List<AiasInfo> aiasInfoList = new ArrayList<>();
		
		ObjectMapper mapper = new ObjectMapper();
		
		String str;
		int zone_id = 100000;
		int title = 0;
		int data_id = 200000;
		while((str = br.readLine()) != null){			
			efInfo = new EFInfo();
			aiasInfo = new AiasInfo();
			if (str.contains("total")) {				
				zoneGeometry = new ZoneGeometry();
				
				
				String[] split = str.split(",");				
				//电子围栏边缘点的个数
				int efTotal = Integer.parseInt((split[0]).split(":")[1]);
				//围栏内随机点的个数
				int aiasTotal = Integer.parseInt((split[1]).split(":")[1]);
				
				//循环读取围栏边缘点的坐标
				for(int i=1;i<=efTotal;i++){
					efPoint = new EFPoint();
					String[] split2 = br.readLine().split(",");					
					efPoint.setLng(split2[0]);
					efPoint.setLat(split2[1]);
					zoneGeometry.getApex().add(efPoint);					
				}
				
				zone_id++;
				efInfo.setZone_id(zone_id);
				
				efInfo.setStyle_id(0);
				
				title++;
				efInfo.setTitle("围栏"+title);
				
				data_id++;
				efInfo.setData_id(data_id);

				zoneGeometry.setType("polygon");
				efInfo.setZone_geometry(zoneGeometry);			
				
				 
				//循环读取围栏内随机点的坐标
				for(int j=1;j<=aiasTotal;j++){
					aiasPoint = new AiasPoint();
					String[] split3 = br.readLine().split(",");
					aiasPoint.setType(2);
					aiasPoint.setLongitude(split3[0]);
					aiasPoint.setLatitude(split3[1]);
					aiasInfo.getData().add(aiasPoint);					
				}
				aiasInfo.setData_id(data_id);								
			}
			if (efInfo!=null) {
				efInfoList.add(efInfo);
			}
			if (aiasInfo!=null) {
				aiasInfoList.add(aiasInfo);
			}
					
			
					
		}
		
		//将组成围栏的点的信息转换成json格式的字符串
		String efpointJson = mapper.writeValueAsString(efInfoList);        
		//将围栏点的json数据输出到文件
        efFos.write(efpointJson.getBytes());
        
        
        //将围栏内的点集信息转换成json格式的字符串
		String aisapointJson = mapper.writeValueAsString(aiasInfoList);          
		//将围栏内的点的json格式数据输出到文件
        aiasFos.write(aisapointJson.getBytes());
        
        
		br.close();
		isr.close();
		fis.close();
		efFos.close();
		aiasFos.close();
	}

}
