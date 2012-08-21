<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="WebForm1.aspx.cs" Inherits="Sos.WebForm1" %>

<%@ Register Assembly="Ext.Net" Namespace="Ext.Net" TagPrefix="ext" %>

<!DOCTYPE html>

<html>
<head id="Head1" runat="server">
    <title>Password Validation - Ext.NET Examples</title>
    <link href="/resources/css/examples.css" rel="stylesheet" type="text/css" />
</head>
<body>
    <form id="Form1" runat="server">
        <ext:ResourceManager ID="ResourceManager1" runat="server" />
        
        <h1>Password Validation</h1>

        <p>This example shows a password verification, the second value must be equivalent to the first to validate.</p>
        
        <ext:Window ID="Window1" 
            runat="server" 
            Width="350"
            AutoHeight="true"
            Title="Password Verification"
            Icon="Textfield"
            Closable="false"
            BodyPadding="5"
            Layout="Form">
            <Defaults>
                <ext:Parameter Name="LabelWidth" Value="125" Mode="Raw" />
            </Defaults>
            <Items>
                <ext:TextField 
                    ID="PasswordField" 
                    runat="server"                    
                    FieldLabel="Password"
                    InputType="Password"
                    AnchorHorizontal="100%"
                    />
                <ext:TextField ID="TextField1" 
                    runat="server"                     
                    Vtype="password"
                    FieldLabel="Confirm Password"
                    InputType="Password"
                    MsgTarget="Side"
                    AnchorHorizontal="100%">     
                    <CustomConfig>
                        <ext:ConfigItem Name="initialPassField" Value="PasswordField" Mode="Value" />
                    </CustomConfig>                      
                </ext:TextField>     
            </Items>            
        </ext:Window>                
   </form>
</body>
</html>