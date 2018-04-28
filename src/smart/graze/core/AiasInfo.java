package smart.graze.core;

import java.util.ArrayList;
import java.util.List;



public class AiasInfo {
	private Integer data_id;
	private List<AiasPoint> data = new ArrayList<>();

	
	
	public Integer getData_id() {
		return data_id;
	}
	public void setData_id(Integer data_id) {
		this.data_id = data_id;
	}
	public List<AiasPoint> getData() {
		return data;
	}
	public void setData(List<AiasPoint> data) {
		this.data = data;
	}
	@Override
	public String toString() {
		return "AiasInfo [data_id=" + data_id + ", data=" + data + "]";
	}

}
