package com.mulesoft.demo.pizza.services;

import javax.jws.WebParam;
import javax.jws.WebService;

@WebService
public interface OrderStatusService {

	public String getOrderStatus(@WebParam(name="orderId") String orderId);
	
}
