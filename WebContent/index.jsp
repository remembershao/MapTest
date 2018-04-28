<!DOCTYPE html>
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	<meta name="viewport" content="initial-scale=1.0, user-scalable=no" />
	<style type="text/css">
	
	body, html{width: 100%;height: 100%;margin:0;font-family:"微软雅黑";}
	#allmap {width: 100%; height:500px; overflow: hidden;}
	#result {width:100%;font-size:12px;}
	dl,dt,dd,ul,li{
		margin:0;
		padding:0;
		list-style:none;
	}
	p{font-size:12px;}
	dt{
		font-size:14px;
		font-family:"微软雅黑";
		font-weight:bold;
		border-bottom:1px dotted #000;
		padding:5px 0 5px 5px;
		margin:5px 0;
	}
	dd{
		padding:5px 0 0 5px;
	}
	li{
		line-height:28px;
	}
	</style>
	<!-- jquery -->
	　<script src="http://code.jquery.com/jquery-2.1.4.min.js"></script>
	<!-- 海量点 -->
	<script type="text/javascript" src="http://lbsyun.baidu.com/jsdemo/data/points-sample-data.js"></script>
	<!-- geoutils -->
	<script src="http://api.map.baidu.com/library/GeoUtils/1.2/src/GeoUtils_min.js" type="text/javascript"></script>
	<script type="text/javascript" src="http://api.map.baidu.com/api?v=2.0&ak=Ym2iDGHu6eaDP1C4GIQgwBE2Uq6DhUDa"></script>
	<!--加载鼠标绘制工具-->
	<script type="text/javascript" src="http://api.map.baidu.com/library/DrawingManager/1.4/src/DrawingManager_min.js"></script>
	<link rel="stylesheet" href="http://api.map.baidu.com/library/DrawingManager/1.4/src/DrawingManager_min.css" />
	<!--加载检索信息窗口-->
	<script type="text/javascript" src="http://api.map.baidu.com/library/SearchInfoWindow/1.4/src/SearchInfoWindow_min.js"></script>
	<link rel="stylesheet" href="http://api.map.baidu.com/library/SearchInfoWindow/1.4/src/SearchInfoWindow_min.css" />
	<title>鼠标绘制工具</title>
</head>
<body>
	
	<div id="map" style="height:90%;-webkit-transition: all 0.5s ease-in-out;transition: all 0.5s ease-in-out;">
	
	</div>
	<div style="heigh:10%;width:100%">
	<input type="button" value="清除所有覆盖物" onclick="clearAll()"/>
	</div>
	<script type="text/javascript">
	/* 1.加载绘图工具
	2.鼠标拖拽绘制多边形
	3.绘制完成之后打印多边形的边界点，并触发添加随机点的函数
	4.添加随机点的函数：
	    根据边界点的经纬度坐标，生成一个外接矩形
	    在矩形内随机生成点，判断点是否在多边形内，如果在，则添加到点集
	    利用点集添加海量点 */
	
	
	// 百度地图API功能
    var map = new BMap.Map('map');
    var poi = new BMap.Point(113.383701,31.69578);//随州市
    map.centerAndZoom(poi,11);
    map.enableScrollWheelZoom(); 
    
    //2D图
    var mapType1 = new BMap.MapTypeControl({mapTypes: [BMAP_NORMAL_MAP,BMAP_HYBRID_MAP]});
	//三维图
    var mapType2 = new BMap.MapTypeControl({anchor: BMAP_ANCHOR_TOP_LEFT});
    map.addControl(mapType1);          //2D图，卫星图
	map.addControl(mapType2);
	map.setCurrentCity("随州市");
    
    //鼠标点击拾取坐标
    map.addEventListener("click",function(e){
	});
    var overlays = [];
	var overlaycomplete = function(e){
        overlays.push(e.overlay);
        //获取多边形点集：Array<Point> 
        var path = e.overlay.getPath();
        var polygon = new BMap.Polygon(path, {strokeColor:"#f50704",fillColor:"#cfcfcf", strokeWeight:5, strokeOpacity:0,fillOpacity:0,});
        var efStr="";
        for(var i=0;i<path.length;i++){
            efStr+=path[i].lng+","+path[i].lat+"\n";
        }
        console.log(efStr);
        radomPoints(path);
    };
    
    //生成随机点函数
    function radomPoints(path){
    	//在多边形内的点集
    	var aiasPoints = new Array();
    	var aiasStr = "";
    
    	//分别记录最小、最大经纬度
    	var minLng = path[0].lng;
    	var maxLng = path[0].lng;
    	var minLat = path[0].lat;
    	var maxLat = path[0].lat;
    	//创建多边形
    	var polygon = new BMap.Polygon(path, {strokeColor:"#f50704",fillColor:"#cfcfcf", strokeWeight:5, strokeOpacity:0,fillOpacity:0,});
    	//创建一个外接矩形
    	for(var i=1;i<path.length;i++){
    		if(path[i].lng>maxLng)
    			maxLng = path[i].lng;
    		if(path[i].lng<minLng)
    			minLng = path[i].lng;
    		if(path[i].lat>maxLat)
    			maxLat = path[i].lat;
    		if(path[i].lat<minLat)
    			minLat = path[i].lat;
    	}
    	lngDist = maxLng - minLng;
    	latDist = maxLat - minLat;
    	//在这个范围内生成点
    	var count = 0;    	
    	 do{
    		lng = minLng + Math.random() * lngDist;
    		lat = minLat + Math.random() * latDist;
    		var point = new BMap.Point(lng,lat);
    		if(BMapLib.GeoUtils.isPointInPolygon(point,polygon)){
    			aiasStr+=point.lng+","+point.lat+"\n";
    			aiasPoints.push(point);
    		    count++;
    		  }
    	}while(count<50); 
    	//打印点集
    	console.log(aiasStr);
    	//添加海量点，判断当前浏览器是否支持添加海量点
    	 if (document.createElement('canvas').getContext) {  // 判断当前浏览器是否支持绘制海量点
    	        
    	        var options = {
    	            size: BMAP_POINT_SIZE_SMALL,
    	            shape: BMAP_POINT_SHAPE_STAR,
    	            color: '#d340c3'
    	        }
    	        var pointCollection = new BMap.PointCollection(aiasPoints, options);  // 初始化PointCollection
    	        pointCollection.addEventListener('click', function (e) {
    	          alert('单击点的坐标为：' + e.point.lng + ',' + e.point.lat);  // 监听点击事件
    	        });
    	        map.addOverlay(pointCollection);  // 添加Overlay
    	    } else {
    	        alert('请在chrome、safari、IE8+以上浏览器查看本示例');
    	    }
    }
    
    var styleOptions = {
        strokeColor:"red",    //边线颜色。
        fillColor:"red",      //填充颜色。当参数为空时，圆形将没有填充效果。
        strokeWeight: 3,       //边线的宽度，以像素为单位。
        strokeOpacity: 0.8,	   //边线透明度，取值范围0 - 1。
        fillOpacity: 0.6,      //填充的透明度，取值范围0 - 1。
        strokeStyle: 'solid' //边线的样式，solid或dashed。
    }
    //实例化鼠标绘制工具
    var drawingManager = new BMapLib.DrawingManager(map, {
        isOpen: false, //是否开启绘制模式
        enableDrawingTool: true, //是否显示工具栏
        drawingToolOptions: {
            anchor: BMAP_ANCHOR_TOP_RIGHT, //位置
            offset: new BMap.Size(5, 5), //偏离值
        },
        circleOptions: styleOptions, //圆的样式
        polylineOptions: styleOptions, //线的样式
        polygonOptions: styleOptions, //多边形的样式
        rectangleOptions: styleOptions //矩形的样式
    });  
	 //添加鼠标绘制工具监听事件，用于获取绘制结果
    drawingManager.addEventListener('overlaycomplete', overlaycomplete);
	 
	 
   // 编写自定义函数,创建标注
	function addMarker(point){
	  var marker = new BMap.Marker(point);
	  map.addOverlay(marker);
	} 
   
   //清楚所有的多边形覆盖物
	function clearAll() {
		for(var i = 0; i < overlays.length; i++){
            map.removeOverlay(overlays[i]);
        }
        overlays.length = 0   
    }
   
   //页面加载
   $(function( ){
	   var points1 = [new BMap.Point(113.263831,31.800918),
	                  new BMap.Point(113.267568,31.798217),
	                  new BMap.Point(113.263831,31.800918),
	                  new BMap.Point(113.263831,31.800918),
	                  new BMap.Point(113.263831,31.800918),
	                  new BMap.Point(113.263831,31.800918),
	                  new BMap.Point(113.263831,31.800918),
	                  new BMap.Point(113.263831,31.800918),
	                  new BMap.Point(113.263831,31.800918),
	                  new BMap.Point(113.263831,31.800918)];
	   var points2 = [];
	   var points3 = [];
	   
   });
     
</script>
</body>
</html>
