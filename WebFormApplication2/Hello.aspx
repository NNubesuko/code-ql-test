<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Hello.aspx.cs" Inherits="WebFormApplication2.Hello" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title></title>
</head>
<body>
    <h2>Hello</h2>
    <form id="form1" runat="server">
        <asp:Label Text="Test Input" runat="server" />
        <asp:TextBox ID="TestInput" runat="server" />
        <asp:Button ID="TestButton" Text="TestButton" runat="server" OnClick="ClickTestButton" />
        <asp:Label ID="Output" Text="" runat="server" />
        
        <br />
        
        <asp:Label Text="Add Button" runat="server" />
        <asp:Label ID="AddResult" Text="" runat="server" />
        <asp:Button ID="AddButton" Text="AddButton" runat="server" OnClick="ClickAddButton" />
        
        <br />
        
        <asp:Label Text="Execution Button" runat="server" />
        <asp:Button ID="ExecutionButton" Text="ExecutionButton" runat="server" OnClick="ClickExecutionButton" />
        
        <br />
        
        <asp:Label Text="Match Input" runat="server" />
        <asp:TextBox ID="MatchInput" runat="server" />
        <asp:TextBox ID="MatchText" runat="server" />
        <asp:Button ID="MatchButton" Text="MatchButton" runat="server" OnClick="ClickMatchButton" />
        <asp:Label ID="MatchOutput" Text="" runat="server" />
        
        <br />
        
        <asp:Label Text="File Input" runat="server" />
        <asp:TextBox ID="FileName" runat="server" />
        <asp:Button ID="FileButton" Text="FileButton" runat="server" OnClick="ClickFileButton" />
        <asp:Label ID="FileOutput" Text="" runat="server" />
        
        <br />
        
        <asp:Button ID="ContextButton" Text="ContextButton" runat="server" OnClick="ClickContextButton" />
        <asp:Label ID="ContextOutput" Text="" runat="server" />
    </form>
</body>
</html>
