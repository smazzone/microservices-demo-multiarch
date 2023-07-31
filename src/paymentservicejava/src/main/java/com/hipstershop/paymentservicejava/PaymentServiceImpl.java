package com.hipstershop.paymentservicejava;

import java.io.InputStream;
import java.net.URL;
import java.nio.charset.StandardCharsets;
import java.util.Random;
import java.util.logging.Logger;

import org.springframework.beans.factory.annotation.Autowired;

import com.google.protobuf.Any;
import com.google.rpc.ErrorInfo;
import com.hipstershop.paymentservicejava.dataaccess.PaymentRecordRepository;
import com.hipstershop.paymentservicejava.model.PaymentRecord;

import hipstershop.PaymentServiceGrpc;
import hipstershop.Payment.ChargeRequest;
import hipstershop.Payment.ChargeResponse;
import io.grpc.protobuf.StatusProto;
import net.devh.boot.grpc.server.service.GrpcService;

@GrpcService
public class PaymentServiceImpl extends PaymentServiceGrpc.PaymentServiceImplBase {
    
    private Logger log = Logger.getLogger("PrmSandboxService");

    @Autowired
    PaymentRecordRepository repo;

    @Override
    public void charge(ChargeRequest request,
        io.grpc.stub.StreamObserver<ChargeResponse> responseObserver) {
            log.info("Charge request received. Storing credit card details for latent charging and chargebacks.");
                    
            String currency = request.getAmount().getCurrencyCode();
            Long amount = request.getAmount().getUnits();
            int nanos = request.getAmount().getNanos();
            String ccNumber = request.getCreditCard().getCreditCardNumber();
        
            
            // perform payment "API call"
            try {
                URL u = new URL("https://developer.paypal.com/");
                InputStream in = u.openStream();
                String response = new String(in.readAllBytes(), StandardCharsets.UTF_8); 
                log.info(String.format("Transaction processed: %s ending %s Amount: %s%d.%d", 
                this.getCardtypeByNumber(ccNumber), 
                ccNumber.substring(ccNumber.length()-5, ccNumber.length()-1), 
                currency,
                amount,
                nanos));
            } catch (Exception e) {
                e.printStackTrace();
            }
            
            Random r = new Random(System.currentTimeMillis());
            if(r.nextBoolean()) {
                for(double i=0; i<500000; i++) { // let's waste some time to make it look like we're waiting for a table lock
                    Math.sqrt(i);
                }           
                this.log.warning("LockTimeOutException occurred. Cannot write to database.");
                com.google.rpc.Status status = com.google.rpc.Status.newBuilder()
                .setCode(com.google.rpc.Code.UNAVAILABLE_VALUE)
                .setMessage("DatabaseLockException")
                .addDetails(Any.pack(ErrorInfo.newBuilder()
                    .setReason("Database table appears to be locked")
                    .setDomain("hipstershop.paymentserviceimpl")
                    .build()))
                .build();
                responseObserver.onError(StatusProto.toStatusRuntimeException(status));
             } else {

                // persist payment data to the database
                PaymentRecord rec = new PaymentRecord();
                String amountS = String.valueOf(amount) + "." + String.valueOf(nanos);
                rec.setAmount(Double.parseDouble(amountS));
                rec.setCreditcardnumber(ccNumber);
                rec.setCvvcode(String.valueOf(request.getCreditCard().getCreditCardCvv()));
                rec.setExpirationMonth(request.getCreditCard().getCreditCardExpirationMonth());
                rec.setExpirationYear(request.getCreditCard().getCreditCardExpirationYear());
                rec.setPaymentstatus("transaction completed");
                
                repo.save(rec);

                // build the response
                ChargeResponse reply = ChargeResponse.newBuilder().
                    setTransactionId("asdfasdfsafd").
                    build();

                responseObserver.onNext(reply);
                responseObserver.onCompleted();
            }
            
    }    

    private String getCardtypeByNumber(String creditcardNumber) {
        if(creditcardNumber.startsWith("4")) {
            return "Visa";
        } else if(creditcardNumber.startsWith("34") || creditcardNumber.startsWith("37")) {
            return "American Express";
        } else if(creditcardNumber.startsWith("5")) {
            return "Mastercard";
        } else {
            return "other";
        }

    }
}
