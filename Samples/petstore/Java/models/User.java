/**
 */

package petstore.models;


/**
 * The User model.
 */
public class User {
    /**
     * The id property.
     */
    private Long id;

    /**
     * The username property.
     */
    private String username;

    /**
     * The firstName property.
     */
    private String firstName;

    /**
     * The lastName property.
     */
    private String lastName;

    /**
     * The email property.
     */
    private String email;

    /**
     * The password property.
     */
    private String password;

    /**
     * The phone property.
     */
    private String phone;

    /**
     * User Status.
     */
    private Integer userStatus;

    /**
     * Get the id value.
     *
     * @return the id value
     */
    public Long getId() {
        return this.id;
    }

    /**
     * Set the id value.
     *
     * @param id the id value to set
     */
    public void setId(Long id) {
        this.id = id;
    }

    /**
     * Get the username value.
     *
     * @return the username value
     */
    public String getUsername() {
        return this.username;
    }

    /**
     * Set the username value.
     *
     * @param username the username value to set
     */
    public void setUsername(String username) {
        this.username = username;
    }

    /**
     * Get the firstName value.
     *
     * @return the firstName value
     */
    public String getFirstName() {
        return this.firstName;
    }

    /**
     * Set the firstName value.
     *
     * @param firstName the firstName value to set
     */
    public void setFirstName(String firstName) {
        this.firstName = firstName;
    }

    /**
     * Get the lastName value.
     *
     * @return the lastName value
     */
    public String getLastName() {
        return this.lastName;
    }

    /**
     * Set the lastName value.
     *
     * @param lastName the lastName value to set
     */
    public void setLastName(String lastName) {
        this.lastName = lastName;
    }

    /**
     * Get the email value.
     *
     * @return the email value
     */
    public String getEmail() {
        return this.email;
    }

    /**
     * Set the email value.
     *
     * @param email the email value to set
     */
    public void setEmail(String email) {
        this.email = email;
    }

    /**
     * Get the password value.
     *
     * @return the password value
     */
    public String getPassword() {
        return this.password;
    }

    /**
     * Set the password value.
     *
     * @param password the password value to set
     */
    public void setPassword(String password) {
        this.password = password;
    }

    /**
     * Get the phone value.
     *
     * @return the phone value
     */
    public String getPhone() {
        return this.phone;
    }

    /**
     * Set the phone value.
     *
     * @param phone the phone value to set
     */
    public void setPhone(String phone) {
        this.phone = phone;
    }

    /**
     * Get the userStatus value.
     *
     * @return the userStatus value
     */
    public Integer getUserStatus() {
        return this.userStatus;
    }

    /**
     * Set the userStatus value.
     *
     * @param userStatus the userStatus value to set
     */
    public void setUserStatus(Integer userStatus) {
        this.userStatus = userStatus;
    }

}
