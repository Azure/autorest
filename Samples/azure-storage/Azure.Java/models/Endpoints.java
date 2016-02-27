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
    public String getBlob() {
        return this.blob;
    }

    /**
     * Set the blob value.
     *
     * @param blob the blob value to set
     */
    public void setBlob(String blob) {
        this.blob = blob;
    }

    /**
     * Get the queue value.
     *
     * @return the queue value
     */
    public String getQueue() {
        return this.queue;
    }

    /**
     * Set the queue value.
     *
     * @param queue the queue value to set
     */
    public void setQueue(String queue) {
        this.queue = queue;
    }

    /**
     * Get the table value.
     *
     * @return the table value
     */
    public String getTable() {
        return this.table;
    }

    /**
     * Set the table value.
     *
     * @param table the table value to set
     */
    public void setTable(String table) {
        this.table = table;
    }

    /**
     * Get the file value.
     *
     * @return the file value
     */
    public String getFile() {
        return this.file;
    }

    /**
     * Set the file value.
     *
     * @param file the file value to set
     */
    public void setFile(String file) {
        this.file = file;
    }

}
