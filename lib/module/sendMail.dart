import 'package:mailer2/mailer.dart';
import 'package:first/const.dart';
class mail{
    String to;
    
    String subject;
    String text;
    
    mail({
      this.to,
      this.subject,
      this.text
    });
    sendMail() {
    
    
    
    // If you want to use an arbitrary SMTP server, go with `new SmtpOptions()`.
    // This class below is just for convenience. There are more similar classes available.
    var options = new GmailSmtpOptions()
      ..username = Const.email
      ..password = Const.password; // Note: if you have Google's "app specific passwords" enabled,
                                          // you need to use one of those here.
                                          
    // How you use and store passwords is up to you. Beware of storing passwords in plain.

    // Create our email transport.
    var emailTransport = new SmtpTransport(options);

    var envelope;
    
    
    // Create mail/envelope
    // if(cc[0].length == 0  && bcc[0].length == 0){
      print("first");
       envelope = new Envelope()
            ..from = Const.email
            ..recipients.add(to)
            ..subject = subject
            ..text = text
            ..html = text;
    // }

    // else if(bcc[0].length == 0){
    //   print("second");
    //    envelope = new Envelope()
    //         ..from = Const.email
    //         ..recipients.add(to)
    //         ..ccRecipients.addAll(cc)
    //         // ..bccRecipients.addAll(bcc)
    //         ..subject = subject
    //         ..text = text
    //         ..html = text;
    // }

    // else if(cc[0].length == 0){
    //   print("third");
    //    envelope = new Envelope()
    //         ..from = Const.email
    //         ..recipients.add(to)
    //         ..bccRecipients.addAll(bcc)
    //         ..subject = subject
    //         ..text = text
    //         ..html = text;
    // }

    // else {
    //   print("forth");
    //    envelope = new Envelope()
    //         ..from = Const.email
    //         ..recipients.add(to)
    //         ..ccRecipients.addAll(cc)
    //         ..bccRecipients.addAll(bcc)
    //         ..subject = subject
    //         ..text = text
    //         ..html = text;
    // }
    
    

    // Email it.
    emailTransport.send(envelope)
      .then((envelope) => correct())
      .catchError((e) => inCorrect(e));
  }

  void correct(){
    print("Email sent");
  }

  void inCorrect(var e){
    print(e);
  }
}


