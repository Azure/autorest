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
    public Long id() {
        return this.id;
    }

    /**
     * Set the id value.
     *
     * @param id the id value to set
     * @return the User object itself.
     */
    public User withId(Long id) {
        this.id = id;
        return this;
    }

    /**
     * Get the username value.
     *
     * @return the username value
     */
    public String username() {
        return this.username;
    }

    /**
     * Set the username value.
     *
     * @param username the username value to set
     * @return the User object itself.
     */
    public User withUsername(String username) {
        this.username = username;
        return this;
    }

    /**
     * Get the firstName value.
     *
     * @return the firstName value
     */
    public String firstName() {
        return this.firstName;
    }

    /**
     * Set the firstName value.
     *
     * @param firstName the firstName value to set
     * @return the User object itself.
     */
    public User withFirstName(String firstName) {
        this.firstName = firstName;
        return this;
    }

    /**
     * Get the lastName value.
     *
     * @return the lastName value
     */
    public String lastName() {
        return this.lastName;
    }

    /**
     * Set the lastName value.
     *
     * @param lastName the lastName value to set
     * @return the User object itself.
     */
    public User withLastName(String lastName) {
        this.lastName = lastName;
        return this;
    }

    /**
     * Get the email value.
     *
     * @return the email value
     */
    public String email() {
        return this.email;
    }

    /**
     * Set the email value.
     *
     * @param email the email value to set
     * @return the User object itself.
     */
    public User withEmail(String email) {
        this.email = email;
        return this;
    }

    /**
     * Get the password value.
     *
     * @return the password value
     */
    public String password() {
        return this.password;
    }

    /**
     * Set the password value.
     *
     * @param password the password value to set
     * @return the User object itself.
     */
    public User withPassword(String password) {
        this.password = password;
        return this;
    }

    /**
     * Get the phone value.
     *
     * @return the phone value
     */
    public String phone() {
        return this.phone;
    }

    /**
     * Set the phone value.
     *
     * @param phone the phone value to set
     * @return the User object itself.
     */
    public User withPhone(String phone) {
        this.phone = phone;
        return this;
    }

    /**
     * Get the userStatus value.
     *
     * @return the userStatus value
     */
    public Integer userStatus() {
        return this.userStatus;
    }

    /**
     * Set the userStatus value.
     *
     * @param userStatus the userStatus value to set
     * @return the User object itself.
     */
    public User withUserStatus(Integer userStatus) {
        this.userStatus = userStatus;
        return this;
    }

}
