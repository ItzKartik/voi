function initPayPalButton(ele) {
    // $('form').hide();
    var amt_parent = ele.parentElement;
    var amt = amt_parent.children[2].value;
    amt_parent.style.display = 'none';
    var par = amt_parent.parentElement;
    ele = par.childNodes[1].childNodes[0].children[0];
    parent.paypal.Buttons({
    style: {
        shape: 'rect',
        color: 'gold',
        layout: 'vertical',
        label: 'paypal',
    },

    createOrder: function(data, actions) {
        return actions.order.create({
        purchase_units: [{"amount":{"currency_code":"USD","value":parseInt(amt)}}]
        });
    },

    onApprove: function(data, actions) {
        return actions.order.capture().then(function(details) {
        alert('Transaction completed by ' + parent.uname + '!');
        ele.style.display = 'none';
        amt_parent.style.display = 'block';
        });
    },

    onError: function(err) {
        console.log(err);
    }
    }).render(ele);
}

function stripe_payment() {
    var stripe = parent.Stripe('pk_test_51Iy7TESHTROt2vsbvjWmIOZEvJjBJ2JX36XTg6MywV644hXwLADs0ISsjgNTKicWsqAkTtZk3Hn4czavyQ8hLu5W00vD2ZjQG4', {
        apiVersion: "2020-08-27",
    });
    var paymentRequest = stripe.paymentRequest({
        country: 'US',
        currency: 'usd',
        total: {
            label: 'Pay Now',
            amount: 20.00,
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
