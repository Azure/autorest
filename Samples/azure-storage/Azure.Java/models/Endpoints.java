/**
 */

package petstore.models;


/**
 * The URIs that are used to perform a retrieval of a public blob, queue or
 * table object.
 */
public class Endpoints {
    /**
     * Gets the blob endpoint.
     */
    private String blob;

    /**
     * Gets the queue endpoint.
     */
    private String queue;

    /**
     * Gets the table endpoint.
     */
    private String table;

    /**
     * Gets the file endpoint.
     */
    private String file;

    /**
     * Get the blob value.
     *
     * @return the blob value
     */
    public String blob() {
        return this.blob;
    }

    /**
     * Set the blob value.
     *
     * @param blob the blob value to set
     * @return the Endpoints object itself.
     */
    public Endpoints withBlob(String blob) {
        this.blob = blob;
        return this;
    }

    /**
     * Get the queue value.
     *
     * @return the queue value
     */
    public String queue() {
        return this.queue;
    }

    /**
     * Set the queue value.
     *
     * @param queue the queue value to set
     * @return the Endpoints object itself.
     */
    public Endpoints withQueue(String queue) {
        this.queue = queue;
        return this;
    }

    /**
     * Get the table value.
     *
     * @return the table value
     */
    public String table() {
        return this.table;
    }

    /**
     * Set the table value.
     *
     * @param table the table value to set
     * @return the Endpoints object itself.
     */
    public Endpoints withTable(String table) {
        this.table = table;
        return this;
    }

    /**
     * Get the file value.
     *
     * @return the file value
     */
    public String file() {
        return this.file;
    }

    /**
     * Set the file value.
     *
     * @param file the file value to set
     * @return the Endpoints object itself.
     */
    public Endpoints withFile(String file) {
        this.file = file;
        return this;
    }

}
