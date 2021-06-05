function runme(ele) {
    var ele = $(ele).parent('payment-div');
    amt = ele.prevObject[0].parentNode.childNodes[2].value;
    amt = amt+".00";
    amt = parseInt(amt);
    var stripe = Stripe('pk_test_51Iy7TESHTROt2vsbvjWmIOZEvJjBJ2JX36XTg6MywV644hXwLADs0ISsjgNTKicWsqAkTtZk3Hn4czavyQ8hLu5W00vD2ZjQG4', {
        apiVersion: "2020-08-27",
    });
    var paymentRequest = stripe.paymentRequest({
        country: 'US',
        currency: 'usd',
        total: {
            label: 'Pay Now',
            amount: amt,
        },
        requestPayerName: true,
        requestPayerEmail: true,
    });

    var elements = stripe.elements();
    var prButton = elements.create('paymentRequestButton', {
        paymentRequest: paymentRequest,
    });
    prButton.mount('#payment-request-button');

    paymentRequest.canMakePayment().then(function (result) {
        var head = $('#tabMake_Payment').contents().find('payment-request-button');
        if (result) {
            prButton.mount(head);
        } else {
            head.style.display = 'none';
        }
    });
}
