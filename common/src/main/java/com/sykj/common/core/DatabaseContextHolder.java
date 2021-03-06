package com.sykj.common.core;

public class DatabaseContextHolder {

	public static final String DATA_SOURCE_A = "dataSourceOne";  
    
    public static final String DATA_SOURCE_B = "dataSourceTwo";
    
    public static final String DATA_SOURCE_C = "dataSourceThree";
    
    public static final String DATA_SOURCE_D = "dataSourceFour";
	
	private static final ThreadLocal<String> contextHolder = new ThreadLocal<String>();  
	  
    public static void setCustomerType(String customerType) {  
        contextHolder.set(customerType);  
    }  
  
    public static String getCustomerType() {  
        return contextHolder.get();  
    }  
  
    public static void clearCustomerType() {  
        contextHolder.remove();  
    }
}
