import {Stripe} from 'https://js.stripe.com/v3/';
function runme() {
    var stripe = Stripe('pk_test_51Iy7TESHTROt2vsbvjWmIOZEvJjBJ2JX36XTg6MywV644hXwLADs0ISsjgNTKicWsqAkTtZk3Hn4czavyQ8hLu5W00vD2ZjQG4', {
        apiVersion: "2020-08-27",
    });
    var paymentRequest = stripe.paymentRequest({
        country: 'US',
        currency: 'usd',
        total: {
            label: 'Pay Now',
            amount: parseInt($('#amount_input').val()),
        },
        requestPayerName: true,
        requestPayerEmail: true,
    });

    var elements = stripe.elements();
    var prButton = elements.create('paymentRequestButton', {
        paymentRequest: paymentRequest,
    });

    paymentRequest.canMakePayment().then(function (result) {
        if (result) {
            prButton.mount('#payment-request-button');
        } else {
            document.getElementById('payment-request-button').style.display = 'none';
        }
    });
}
