package com.mulesoft.demo.pizza.services;

import javax.jws.WebParam;
import javax.jws.WebService;

@WebService
public interface PizzaOrderService {

	public String placeOrder(@WebParam(name="order") PizzaOrder order);
	
}
