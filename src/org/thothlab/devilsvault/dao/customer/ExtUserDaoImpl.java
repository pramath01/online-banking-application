package org.thothlab.devilsvault.dao.customer;
import java.math.BigInteger;
import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import javax.sql.DataSource;

import java.sql.Statement;
import org.springframework.jdbc.support.GeneratedKeyHolder;
import org.springframework.jdbc.support.KeyHolder;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Repository;
import org.thothlab.devilsvault.db.model.BankAccountDB;
import org.thothlab.devilsvault.db.model.BankAccountExternal;
import org.thothlab.devilsvault.db.model.Customer;
@Repository ("ExtUserDaoImpl")
public class ExtUserDaoImpl{
	@SuppressWarnings("unused")
	private JdbcTemplate jdbcTemplate;
	private DataSource dataSource;
	@Autowired
	public void setdataSource(DataSource dataSource) {
		this.dataSource = dataSource;
		this.jdbcTemplate = new JdbcTemplate(dataSource);
	}
	public BankAccountDB getAccount(Customer user,BankAccountDB bankAccount,String accountType)
	{
		Connection con = null;
		PreparedStatement ps = null;
		ResultSet rs = null;
		String sql ="SELECT * FROM  bank_accounts WHERE external_users_id="+user.getId()+" and account_type='"+accountType+"'";
		try{
			con = dataSource.getConnection();
			ps = con.prepareStatement(sql);
			rs = ps.executeQuery();
			while(rs.next())
			{
				bankAccount.setAccount_number(rs.getInt("account_number"));
				bankAccount.setAccount_type(rs.getString("account_type"));
				bankAccount.setHold(rs.getBigDecimal("hold"));
				bankAccount.setBalance(rs.getBigDecimal("balance").subtract(bankAccount.getHold()));
				bankAccount.setExternal_user_id(rs.getInt("external_users_id"));
			}
		}catch(SQLException e){
			e.printStackTrace();
		}finally{
			try {
				rs.close();
				ps.close();
				con.close();
			} catch (SQLException e) {
				e.printStackTrace();
			}
		}
		return bankAccount;
     }
	
	public Double getSavingsBalance(Customer user)
	{
		Connection con = null;
		PreparedStatement ps = null;
		ResultSet rs = null;
		String sql ="SELECT balance FROM  bank_accounts WHERE external_users_id="+user.getId()+" and account_type='SAVINGS'";
		Double balance = 0.0d;
		try{
			con = dataSource.getConnection();
			ps = con.prepareStatement(sql);
			rs = ps.executeQuery();
			while(rs.next())
			{
				balance = rs.getDouble("balance");
			}
		}catch(SQLException e){
			e.printStackTrace();
		}finally{
			try {
				rs.close();
				ps.close();
				con.close();
			} catch (SQLException e) {
				e.printStackTrace();
			}
		}
		return balance;
     }
	public Double getCheckingBalance(Customer user)
	{
		Connection con = null;
		PreparedStatement ps = null;
		ResultSet rs = null;
		String sql ="SELECT balance FROM  bank_accounts WHERE external_users_id="+user.getId()+" and account_type='CHECKINGS'";
		Double balance = 0.0d;
		try{
			con = dataSource.getConnection();
			ps = con.prepareStatement(sql);
			rs = ps.executeQuery();
			while(rs.next())
			{
				balance = rs.getDouble("balance");
			}
		}catch(SQLException e){
			e.printStackTrace();
		}finally{
			try {
				rs.close();
				ps.close();
				con.close();
			} catch (SQLException e) {
				e.printStackTrace();
			}
		}
		return balance;
     }
	
	public Customer setExternalUser(String name,String address,BigInteger phone,String email, String date_of_birth,String ssn)
    {
        Customer userDetails = new Customer();
        userDetails.setName(name);
        userDetails.setAddress(address);
        userDetails.setDate_of_birth(date_of_birth);
        userDetails.setEmail(email);
        userDetails.setPhone(phone);
        userDetails.setSsn(ssn);
        return userDetails;
    }

	public Integer createUser(Customer userdetails) {
		// Corrected query: We do NOT provide a value for the auto-incrementing 'id' column.
		// The hardcoded city/state/country/pincode values are kept as they were in your original code.
		String query = "INSERT INTO external_users (name, address, city, state, country, pincode, phone, email, date_of_birth, ssn) " +
				"VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

		// KeyHolder is a Spring utility that will hold the auto-generated key (the ID)
		KeyHolder keyHolder = new GeneratedKeyHolder();

		jdbcTemplate.update(connection -> {
			PreparedStatement ps = connection.prepareStatement(query, Statement.RETURN_GENERATED_KEYS);
			ps.setString(1, userdetails.getName());
			ps.setString(2, userdetails.getAddress());
			ps.setString(3, "sdsdsad"); // Hardcoded value from your original code
			ps.setString(4, "sdsdsad"); // Hardcoded value from your original code
			ps.setString(5, "sdsdsad"); // Hardcoded value from your original code
			ps.setInt(6, 123);           // Hardcoded value from your original code
			// Assuming phone is BigInteger, convert to long for the database
			ps.setLong(7, userdetails.getPhone().longValue());
			ps.setString(8, userdetails.getEmail());
			ps.setString(9, userdetails.getDate_of_birth());
			ps.setString(10, userdetails.getSsn());
			return ps;
		}, keyHolder);

		// After the update, the keyHolder contains the new ID. We retrieve and return it.
		if (keyHolder.getKey() != null) {
			return keyHolder.getKey().intValue();
		} else {
			// This is a robust way to handle an unexpected failure.
			throw new RuntimeException("Failed to retrieve auto-generated key for new external user: " + userdetails.getEmail());
		}
	}
	
	public BankAccountDB getCreditCardBalance(BankAccountDB account)
	{
		boolean status=false;
		Connection con = null;
		PreparedStatement ps = null;
		ResultSet rs = null;
		String query_CCbalance ="select available_balance from credit_card_account_details where account_number = "+account.getAccount_number();
		System.out.println("credit card account num - "+account.getAccount_number());
		try
		{
			con = dataSource.getConnection();
			ps = con.prepareStatement(query_CCbalance);
			rs = ps.executeQuery();
			rs.next();
			account.setBalance(rs.getBigDecimal(1));
				
		}catch(SQLException e){
			status = false;
			e.printStackTrace();
		}finally{
			try {
					ps.close();
					con.close();
			} catch (SQLException e) {
				e.printStackTrace();
			}
		}
		return account;
     }
	
	public BankAccountExternal getAccount(Customer user,BankAccountExternal bankAccount,String accountType)
	{
		Connection con = null;
		PreparedStatement ps = null;
		ResultSet rs = null;
		String sql ="SELECT * FROM  bank_accounts WHERE external_users_id="+user.getId()+" and account_type='"+accountType+"'";
		try{
			con = dataSource.getConnection();
			ps = con.prepareStatement(sql);
			rs = ps.executeQuery();
			while(rs.next())
			{
				bankAccount.setAccount_number(rs.getInt("account_number"));
				bankAccount.setAccount_type(rs.getString("account_type"));
				bankAccount.setBalance(rs.getFloat("balance"));
				bankAccount.setExternal_users_id(rs.getInt("external_users_id"));
			}
		}catch(SQLException e){
			e.printStackTrace();
		}finally{
			try {
				rs.close();
				ps.close();
				con.close();
			} catch (SQLException e) {
				e.printStackTrace();
			}
		}
		return bankAccount;
     }
}
