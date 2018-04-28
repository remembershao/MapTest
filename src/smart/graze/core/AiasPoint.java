package smart.graze.core;

public class AiasPoint {
	private Integer type;
	private String latitude;
	private String longitude;
	public Integer getType() {
		return type;
	}
	public void setType(Integer type) {
		this.type = type;
	}
	public String getLatitude() {
		return latitude;
	}
	public void setLatitude(String latitude) {
		this.latitude = latitude;
	}
	public String getLongitude() {
		return longitude;
	}
	public void setLongitude(String longitude) {
		this.longitude = longitude;
	}
	@Override
	public String toString() {
		return "AiasPoint [type=" + type + ", latitude=" + latitude + ", longitude=" + longitude + "]";
	}

}
