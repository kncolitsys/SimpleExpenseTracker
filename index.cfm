<!DOCTYPE html>
<html >
	<body>
		<h2>Add Expense</h2>
		<form >
			<table >
				<tr>
					<td>Date:</td> <td><input type="date" id="dateTxt"></td>
				</tr>
				<tr>
					<td>Amount:</td> <td><input type="number" id="amtTxt"></td>
				</tr>
				<tr>
					<td>Description</td>
					<td><input type="text" id="descTxt"></td>
				</tr>
				<tr>
					<td colspan="2">
						<button type="button" id="addBtn">Add</button>
					</td>
				</tr>
			</table>
		</form>
		
		<h2>Expenses:</h2>
		<table id="expList">
			<tr>
				<th>Date</th>
				<th>Amount</th>
				<th>Description</th>
			</tr>
		</table>
	</body>
</html>

<script >
	document.getElementById("addBtn").onclick = function(){
		addExpense();
	}
</script>

<!--- cfclient code starts here --->
<cfclient>

	<!--- on client side you do not need to pre-configure datasource --->
	<cfset variables.dsn = "expense_db">
	
	<!--- create database if not already created --->
	<cfquery datasource="#variables.dsn#">
		create table if not exists expense (
			id integer primary key,
			expense_date integer,
			amount real,
			desc text
		)
	</cfquery>
	
	<!--- Get expense records from the table --->
	<cfquery datasource="#variables.dsn#" name="expenses">
		select * from expense order by expense_date desc
	</cfquery>
	
	<!--- Loop over expenses query object and display --->
	<cfloop query="rs">
		<cfset var tmpDate = new Date(expense_date)>
		<cfset addExpenseRow(expense_date,amount,desc)>
	</cfloop>
	
	<!--- Helper function to add epxpense row to HTML table --->
	<cffunction name="addExpenseRow" >
		<cfargument name="expense_date" >
		<cfargument name="amt" >
		<cfargument name="desc" >
		
		<cfoutput >
			<cfsavecontent variable="rowHtml" >
				<tr>
					<td>#dateFormat(expense_date,"mm/dd/yyyy")#</td>
					<td>#amt#</td>
					<td>#desc#</td>
				</tr>
			</cfsavecontent>
		</cfoutput>
		
		<cfset document.getElementById("expList").innerHTML += rowHtml>
	</cffunction>
	
	<!--- Called from JS script block in response to click event for addBtn --->
	<cffunction name="addExpense" >
		<cfset var tmpDate = new Date(document.getElementById("dateTxt").value)>
		<cfset var amt = Number(document.getElementById("amtTxt").value)>
		<cfset var desc = document.getElementById("descTxt").value>

		<!--- TODO: Do data validation --->
		
		<!--- Insert expense row into database table --->		
		<cfquery datasource="#variables.dsn#">
			insert into expense (expense_date,amount,desc) values(
				<cfqueryparam cfsqltype="cf_sql_date" value="#tmpDate.getTime()#">,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#amt#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#desc#">
			)
		</cfquery>
		
		<!--- add the new expense row to HTML table --->
		<cfset addExpenseRow(tmpDate,amt,desc)>
	</cffunction>
	
</cfclient>