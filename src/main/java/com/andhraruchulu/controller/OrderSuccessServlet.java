
package com.andhraruchulu.controller;

import java.io.IOException;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/order-success")
public class OrderSuccessServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect(
                request.getContextPath() + "/Login.jsp"
            );
            return;
        }

        Object orderId = session.getAttribute("lastOrderId");
        Object paymentMethod =
            session.getAttribute("lastPaymentMethod");

        // Show the actual problem instead of silently redirecting.
        if (orderId == null || paymentMethod == null) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            request.setAttribute(
                "errorMessage",
                "Order details are missing. Please check whether your order was saved."
            );

            request.getRequestDispatcher("/OrderError.jsp")
                   .forward(request, response);
            return;
        }

        request.setAttribute("orderId", orderId);
        request.setAttribute("paymentMethod", paymentMethod);

        if ("COD".equals(paymentMethod.toString())) {
            request.setAttribute(
                "paymentStatus", "Pay on delivery"
            );
        } else {
            request.setAttribute(
                "paymentStatus",
                "Pending payment confirmation"
            );
        }

        request.getRequestDispatcher("/OrderSuccess.jsp")
               .forward(request, response);
    }
}
