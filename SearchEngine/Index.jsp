<%@page import="java.util.*"%>
<%@page import="java.io.*"%>
<%@page import="java.lang.*"%>
<%
String result = request.getParameter("search");
String[] parts = result.split(" ");
ArrayList<String> ANS = new ArrayList<String>();
String urlRedirect = "Search.jsp";
//
for (int i = 0; i<parts.length;i++){
    if (parts[i].equals("and"))
    {
    ANS.add("Value &");
    }
    else if (parts[i].equals("or"))
    {
     ANS.add("Value |");
    }
    else if (parts[i].equals("not"))
    {
    ANS.add("Value ~");
    }
    else
    {
        for (int j=1 ;j<=3 ;j++){
        String txtFilePath = application.getRealPath("/SearchEngine/file"+j+".txt");
        File file = new File(txtFilePath);
        Scanner scanner = new Scanner(file);

        while (scanner.hasNextLine()) {
        final String lineFromFile = scanner.nextLine();
        if(lineFromFile.contains(parts[i])) { 
        ANS.add(parts[i]+ " 1"); // result;
        break;
        }
        else{
           ANS.add(parts[i]+ " 0"); 
           break;
        }
     }
   }
 }
 //
}
  // calculate the ANS;  
  // this list sperates the data;
ArrayList<String> fin  = new ArrayList<String>();
 for (int i =0; i< ANS.size();i++ ){
    String[] partition = ANS.get(i).split(" ");
    String x1 = partition[0]; // Eg. Apple;
    String x2 = partition[1]; // Eg. 1
    //
    fin.add(x1);
    fin.add(x2);
 }

 // the if condition;=> final arraylist;
 ArrayList <String> FinalUsage = new ArrayList<String>();
 for (int i =0; i< fin.size();i++ ){
     if (fin.get(i).equals("0")||fin.get(i).equals("1")||fin.get(i).equals("&")||
     fin.get(i).equals("|")||fin.get(i).equals("~")){
      FinalUsage.add(fin.get(i));
     }
 }
 // Calculation of final usage;
ArrayList<String> val = new ArrayList<String>();
ArrayList<String> valSign = new ArrayList<String>();

 String wer = "";
 for (int i = 0; i<FinalUsage.size();i++){
    if (FinalUsage.get(i).equals("0") || FinalUsage.get(i).equals("1")){
     wer += FinalUsage.get(i).toString();
    }
    else{
     valSign.add(FinalUsage.get(i));
    }
 }

 int r1 = 0;
 int r2 = 3;
 int werLength = wer.length()/3;
 for (int i = 1 ;i<=werLength;i++){
    
     String recent = wer.substring(r1,r2);
     val.add(recent);
    
     r1+=3;
     r2+=3;
 }

ArrayList<Integer> valDecimal = new ArrayList<Integer>();
// val => convert to valDecimal(real number);
for (int i = 0;i<val.size();i++){
valDecimal.add(Integer.parseInt(val.get(i),2));

}


int big=0  ;
try{
if (!valSign.isEmpty()) {
for (int i =0 ;i<valSign.size();i++){
    for (int j =0 ;j<valDecimal.size();j++){

  if (valSign.get(i).equals("&")){
      if (j == 0){
           big = valDecimal.get(j)&valDecimal.get(j+1);
      }else{
        big = big & valDecimal.get(j+1);
      }
  }
   if (valSign.get(i).equals("|")){
      if (j == 0){
           big =valDecimal.get(j)|valDecimal.get(j+1);
      }else{
        big = big | valDecimal.get(j+1);
      }
  }
   if (valSign.get(i).equals("~")){
      if (j == 0){
          big = (~ valDecimal.get(j+1)) & valDecimal.get(j);
      }else{
       big = (~ valDecimal.get(j+1)) & big ;
      }
  }
    }
 }
}else{
    big = valDecimal.get(0); 
}
}catch(Exception e){}

ArrayList<String> HTML_OUTPUT = new ArrayList<String>();
String BinaryResult = Integer.toBinaryString(big);
if (BinaryResult.length()<3){
  BinaryResult = "0"+BinaryResult;
  if (BinaryResult.length()==2){
    BinaryResult = "0"+BinaryResult;
 }
}
 
try{
String[] TheFinalOuput = BinaryResult.split("");
if (TheFinalOuput[0].equals("1")){
HTML_OUTPUT.add("Found in File1");
}

 if (TheFinalOuput[1].equals("1")){
HTML_OUTPUT.add("Found in File2");
}

 if (TheFinalOuput[2].equals("1")){
HTML_OUTPUT.add("Found in File3");
}
}catch(Exception e){}
session.setAttribute("result",HTML_OUTPUT.toString());
response.sendRedirect(urlRedirect);

%>

<html>


<head>
<%=parts[0]%>
<p>


<%=ANS.toString()%>
<p>
<%=fin%>

<p>
the final usage list
<%=FinalUsage%>
<p>
<p>
<%=wer%>
<%=valSign%>
 <%=werLength%>
 <p>
Val
 <%=val%>
  <p>
  ValSign
 <%=valSign%>
 <p>
 val decimal 
 <%=valDecimal%>
 <p>
 THIS IS Calculated value in decimal
 <%=big%>
 <p>
 final binary result
 <%=BinaryResult%>
 <p>
 <%=HTML_OUTPUT.toString()%>
</head>
</html>