/**
 * Copyright (c) Microsoft Corporation. All rights reserved.
 * Licensed under the MIT License. See License.txt in the project root for
 * license information.
 *
 * Code generated by Microsoft (R) AutoRest Code Generator.
 * Changes may cause incorrect behavior and will be lost if the code is
 * regenerated.
 */

package fixtures.bodystring;

import com.microsoft.rest.ServiceCall;
import com.microsoft.rest.ServiceCallback;
import com.microsoft.rest.ServiceResponse;
import rx.Observable;

/**
 * An instance of this class provides access to all the operations defined
 * in Strings.
 */
public interface Strings {
    /**
     * Get null string value value.
     *
     * @return the String object if successful.
     */
    String getNull();

    /**
     * Get null string value value.
     *
     * @param serviceCallback the async ServiceCallback to handle successful and failed responses.
     * @return the {@link ServiceCall} object
     */
    ServiceCall<String> getNullAsync(final ServiceCallback<String> serviceCallback);

    /**
     * Get null string value value.
     *
     * @return the observable to the String object
     */
    Observable<String> getNullAsync();

    /**
     * Get null string value value.
     *
     * @return the observable to the String object
     */
    Observable<ServiceResponse<String>> getNullWithServiceResponseAsync();

    /**
     * Set string value null.
     *
     */
    void putNull();

    /**
     * Set string value null.
     *
     * @param serviceCallback the async ServiceCallback to handle successful and failed responses.
     * @return the {@link ServiceCall} object
     */
    ServiceCall<Void> putNullAsync(final ServiceCallback<Void> serviceCallback);

    /**
     * Set string value null.
     *
     * @return the {@link ServiceResponse} object if successful.
     */
    Observable<Void> putNullAsync();

    /**
     * Set string value null.
     *
     * @return the {@link ServiceResponse} object if successful.
     */
    Observable<ServiceResponse<Void>> putNullWithServiceResponseAsync();
    /**
     * Set string value null.
     *
     * @param stringBody Possible values include: ''
     */
    void putNull(String stringBody);

    /**
     * Set string value null.
     *
     * @param stringBody Possible values include: ''
     * @param serviceCallback the async ServiceCallback to handle successful and failed responses.
     * @return the {@link ServiceCall} object
     */
    ServiceCall<Void> putNullAsync(String stringBody, final ServiceCallback<Void> serviceCallback);

    /**
     * Set string value null.
     *
     * @param stringBody Possible values include: ''
     * @return the {@link ServiceResponse} object if successful.
     */
    Observable<Void> putNullAsync(String stringBody);

    /**
     * Set string value null.
     *
     * @param stringBody Possible values include: ''
     * @return the {@link ServiceResponse} object if successful.
     */
    Observable<ServiceResponse<Void>> putNullWithServiceResponseAsync(String stringBody);

    /**
     * Get empty string value value ''.
     *
     * @return the String object if successful.
     */
    String getEmpty();

    /**
     * Get empty string value value ''.
     *
     * @param serviceCallback the async ServiceCallback to handle successful and failed responses.
     * @return the {@link ServiceCall} object
     */
    ServiceCall<String> getEmptyAsync(final ServiceCallback<String> serviceCallback);

    /**
     * Get empty string value value ''.
     *
     * @return the observable to the String object
     */
    Observable<String> getEmptyAsync();

    /**
     * Get empty string value value ''.
     *
     * @return the observable to the String object
     */
    Observable<ServiceResponse<String>> getEmptyWithServiceResponseAsync();

    /**
     * Set string value empty ''.
     *
     * @param stringBody Possible values include: ''
     */
    void putEmpty(String stringBody);

    /**
     * Set string value empty ''.
     *
     * @param stringBody Possible values include: ''
     * @param serviceCallback the async ServiceCallback to handle successful and failed responses.
     * @return the {@link ServiceCall} object
     */
    ServiceCall<Void> putEmptyAsync(String stringBody, final ServiceCallback<Void> serviceCallback);

    /**
     * Set string value empty ''.
     *
     * @param stringBody Possible values include: ''
     * @return the {@link ServiceResponse} object if successful.
     */
    Observable<Void> putEmptyAsync(String stringBody);

    /**
     * Set string value empty ''.
     *
     * @param stringBody Possible values include: ''
     * @return the {@link ServiceResponse} object if successful.
     */
    Observable<ServiceResponse<Void>> putEmptyWithServiceResponseAsync(String stringBody);

    /**
     * Get mbcs string value '啊齄丂狛狜隣郎隣兀﨩ˊ▇█〞〡￤℡㈱‐ー﹡﹢﹫、〓ⅰⅹ⒈€㈠㈩ⅠⅫ！￣ぁんァヶΑ︴АЯаяāɡㄅㄩ─╋︵﹄︻︱︳︴ⅰⅹɑɡ〇〾⿻⺁䜣€ '.
     *
     * @return the String object if successful.
     */
    String getMbcs();

    /**
     * Get mbcs string value '啊齄丂狛狜隣郎隣兀﨩ˊ▇█〞〡￤℡㈱‐ー﹡﹢﹫、〓ⅰⅹ⒈€㈠㈩ⅠⅫ！￣ぁんァヶΑ︴АЯаяāɡㄅㄩ─╋︵﹄︻︱︳︴ⅰⅹɑɡ〇〾⿻⺁䜣€ '.
     *
     * @param serviceCallback the async ServiceCallback to handle successful and failed responses.
     * @return the {@link ServiceCall} object
     */
    ServiceCall<String> getMbcsAsync(final ServiceCallback<String> serviceCallback);

    /**
     * Get mbcs string value '啊齄丂狛狜隣郎隣兀﨩ˊ▇█〞〡￤℡㈱‐ー﹡﹢﹫、〓ⅰⅹ⒈€㈠㈩ⅠⅫ！￣ぁんァヶΑ︴АЯаяāɡㄅㄩ─╋︵﹄︻︱︳︴ⅰⅹɑɡ〇〾⿻⺁䜣€ '.
     *
     * @return the observable to the String object
     */
    Observable<String> getMbcsAsync();

    /**
     * Get mbcs string value '啊齄丂狛狜隣郎隣兀﨩ˊ▇█〞〡￤℡㈱‐ー﹡﹢﹫、〓ⅰⅹ⒈€㈠㈩ⅠⅫ！￣ぁんァヶΑ︴АЯаяāɡㄅㄩ─╋︵﹄︻︱︳︴ⅰⅹɑɡ〇〾⿻⺁䜣€ '.
     *
     * @return the observable to the String object
     */
    Observable<ServiceResponse<String>> getMbcsWithServiceResponseAsync();

    /**
     * Set string value mbcs '啊齄丂狛狜隣郎隣兀﨩ˊ▇█〞〡￤℡㈱‐ー﹡﹢﹫、〓ⅰⅹ⒈€㈠㈩ⅠⅫ！￣ぁんァヶΑ︴АЯаяāɡㄅㄩ─╋︵﹄︻︱︳︴ⅰⅹɑɡ〇〾⿻⺁䜣€ '.
     *
     * @param stringBody Possible values include: '啊齄丂狛狜隣郎隣兀﨩ˊ▇█〞〡￤℡㈱‐ー﹡﹢﹫、〓ⅰⅹ⒈€㈠㈩ⅠⅫ！￣ぁんァヶΑ︴АЯаяāɡㄅㄩ─╋︵﹄︻︱︳︴ⅰⅹɑɡ〇〾⿻⺁䜣€ '
     */
    void putMbcs(String stringBody);

    /**
     * Set string value mbcs '啊齄丂狛狜隣郎隣兀﨩ˊ▇█〞〡￤℡㈱‐ー﹡﹢﹫、〓ⅰⅹ⒈€㈠㈩ⅠⅫ！￣ぁんァヶΑ︴АЯаяāɡㄅㄩ─╋︵﹄︻︱︳︴ⅰⅹɑɡ〇〾⿻⺁䜣€ '.
     *
     * @param stringBody Possible values include: '啊齄丂狛狜隣郎隣兀﨩ˊ▇█〞〡￤℡㈱‐ー﹡﹢﹫、〓ⅰⅹ⒈€㈠㈩ⅠⅫ！￣ぁんァヶΑ︴АЯаяāɡㄅㄩ─╋︵﹄︻︱︳︴ⅰⅹɑɡ〇〾⿻⺁䜣€ '
     * @param serviceCallback the async ServiceCallback to handle successful and failed responses.
     * @return the {@link ServiceCall} object
     */
    ServiceCall<Void> putMbcsAsync(String stringBody, final ServiceCallback<Void> serviceCallback);

    /**
     * Set string value mbcs '啊齄丂狛狜隣郎隣兀﨩ˊ▇█〞〡￤℡㈱‐ー﹡﹢﹫、〓ⅰⅹ⒈€㈠㈩ⅠⅫ！￣ぁんァヶΑ︴АЯаяāɡㄅㄩ─╋︵﹄︻︱︳︴ⅰⅹɑɡ〇〾⿻⺁䜣€ '.
     *
     * @param stringBody Possible values include: '啊齄丂狛狜隣郎隣兀﨩ˊ▇█〞〡￤℡㈱‐ー﹡﹢﹫、〓ⅰⅹ⒈€㈠㈩ⅠⅫ！￣ぁんァヶΑ︴АЯаяāɡㄅㄩ─╋︵﹄︻︱︳︴ⅰⅹɑɡ〇〾⿻⺁䜣€ '
     * @return the {@link ServiceResponse} object if successful.
     */
    Observable<Void> putMbcsAsync(String stringBody);

    /**
     * Set string value mbcs '啊齄丂狛狜隣郎隣兀﨩ˊ▇█〞〡￤℡㈱‐ー﹡﹢﹫、〓ⅰⅹ⒈€㈠㈩ⅠⅫ！￣ぁんァヶΑ︴АЯаяāɡㄅㄩ─╋︵﹄︻︱︳︴ⅰⅹɑɡ〇〾⿻⺁䜣€ '.
     *
     * @param stringBody Possible values include: '啊齄丂狛狜隣郎隣兀﨩ˊ▇█〞〡￤℡㈱‐ー﹡﹢﹫、〓ⅰⅹ⒈€㈠㈩ⅠⅫ！￣ぁんァヶΑ︴АЯаяāɡㄅㄩ─╋︵﹄︻︱︳︴ⅰⅹɑɡ〇〾⿻⺁䜣€ '
     * @return the {@link ServiceResponse} object if successful.
     */
    Observable<ServiceResponse<Void>> putMbcsWithServiceResponseAsync(String stringBody);

    /**
     * Get string value with leading and trailing whitespace '&lt;tab&gt;&lt;space&gt;&lt;space&gt;Now is the time for all good men to come to the aid of their country&lt;tab&gt;&lt;space&gt;&lt;space&gt;'.
     *
     * @return the String object if successful.
     */
    String getWhitespace();

    /**
     * Get string value with leading and trailing whitespace '&lt;tab&gt;&lt;space&gt;&lt;space&gt;Now is the time for all good men to come to the aid of their country&lt;tab&gt;&lt;space&gt;&lt;space&gt;'.
     *
     * @param serviceCallback the async ServiceCallback to handle successful and failed responses.
     * @return the {@link ServiceCall} object
     */
    ServiceCall<String> getWhitespaceAsync(final ServiceCallback<String> serviceCallback);

    /**
     * Get string value with leading and trailing whitespace '&lt;tab&gt;&lt;space&gt;&lt;space&gt;Now is the time for all good men to come to the aid of their country&lt;tab&gt;&lt;space&gt;&lt;space&gt;'.
     *
     * @return the observable to the String object
     */
    Observable<String> getWhitespaceAsync();

    /**
     * Get string value with leading and trailing whitespace '&lt;tab&gt;&lt;space&gt;&lt;space&gt;Now is the time for all good men to come to the aid of their country&lt;tab&gt;&lt;space&gt;&lt;space&gt;'.
     *
     * @return the observable to the String object
     */
    Observable<ServiceResponse<String>> getWhitespaceWithServiceResponseAsync();

    /**
     * Set String value with leading and trailing whitespace '&lt;tab&gt;&lt;space&gt;&lt;space&gt;Now is the time for all good men to come to the aid of their country&lt;tab&gt;&lt;space&gt;&lt;space&gt;'.
     *
     * @param stringBody Possible values include: '    Now is the time for all good men to come to the aid of their country    '
     */
    void putWhitespace(String stringBody);

    /**
     * Set String value with leading and trailing whitespace '&lt;tab&gt;&lt;space&gt;&lt;space&gt;Now is the time for all good men to come to the aid of their country&lt;tab&gt;&lt;space&gt;&lt;space&gt;'.
     *
     * @param stringBody Possible values include: '    Now is the time for all good men to come to the aid of their country    '
     * @param serviceCallback the async ServiceCallback to handle successful and failed responses.
     * @return the {@link ServiceCall} object
     */
    ServiceCall<Void> putWhitespaceAsync(String stringBody, final ServiceCallback<Void> serviceCallback);

    /**
     * Set String value with leading and trailing whitespace '&lt;tab&gt;&lt;space&gt;&lt;space&gt;Now is the time for all good men to come to the aid of their country&lt;tab&gt;&lt;space&gt;&lt;space&gt;'.
     *
     * @param stringBody Possible values include: '    Now is the time for all good men to come to the aid of their country    '
     * @return the {@link ServiceResponse} object if successful.
     */
    Observable<Void> putWhitespaceAsync(String stringBody);

    /**
     * Set String value with leading and trailing whitespace '&lt;tab&gt;&lt;space&gt;&lt;space&gt;Now is the time for all good men to come to the aid of their country&lt;tab&gt;&lt;space&gt;&lt;space&gt;'.
     *
     * @param stringBody Possible values include: '    Now is the time for all good men to come to the aid of their country    '
     * @return the {@link ServiceResponse} object if successful.
     */
    Observable<ServiceResponse<Void>> putWhitespaceWithServiceResponseAsync(String stringBody);

    /**
     * Get String value when no string value is sent in response payload.
     *
     * @return the String object if successful.
     */
    String getNotProvided();

    /**
     * Get String value when no string value is sent in response payload.
     *
     * @param serviceCallback the async ServiceCallback to handle successful and failed responses.
     * @return the {@link ServiceCall} object
     */
    ServiceCall<String> getNotProvidedAsync(final ServiceCallback<String> serviceCallback);

    /**
     * Get String value when no string value is sent in response payload.
     *
     * @return the observable to the String object
     */
    Observable<String> getNotProvidedAsync();

    /**
     * Get String value when no string value is sent in response payload.
     *
     * @return the observable to the String object
     */
    Observable<ServiceResponse<String>> getNotProvidedWithServiceResponseAsync();

    /**
     * Get value that is base64 encoded.
     *
     * @return the byte[] object if successful.
     */
    byte[] getBase64Encoded();

    /**
     * Get value that is base64 encoded.
     *
     * @param serviceCallback the async ServiceCallback to handle successful and failed responses.
     * @return the {@link ServiceCall} object
     */
    ServiceCall<byte[]> getBase64EncodedAsync(final ServiceCallback<byte[]> serviceCallback);

    /**
     * Get value that is base64 encoded.
     *
     * @return the observable to the byte[] object
     */
    Observable<byte[]> getBase64EncodedAsync();

    /**
     * Get value that is base64 encoded.
     *
     * @return the observable to the byte[] object
     */
    Observable<ServiceResponse<byte[]>> getBase64EncodedWithServiceResponseAsync();

    /**
     * Get value that is base64url encoded.
     *
     * @return the byte[] object if successful.
     */
    byte[] getBase64UrlEncoded();

    /**
     * Get value that is base64url encoded.
     *
     * @param serviceCallback the async ServiceCallback to handle successful and failed responses.
     * @return the {@link ServiceCall} object
     */
    ServiceCall<byte[]> getBase64UrlEncodedAsync(final ServiceCallback<byte[]> serviceCallback);

    /**
     * Get value that is base64url encoded.
     *
     * @return the observable to the byte[] object
     */
    Observable<byte[]> getBase64UrlEncodedAsync();

    /**
     * Get value that is base64url encoded.
     *
     * @return the observable to the byte[] object
     */
    Observable<ServiceResponse<byte[]>> getBase64UrlEncodedWithServiceResponseAsync();

    /**
     * Put value that is base64url encoded.
     *
     * @param stringBody the Base64Url value
     */
    void putBase64UrlEncoded(byte[] stringBody);

    /**
     * Put value that is base64url encoded.
     *
     * @param stringBody the Base64Url value
     * @param serviceCallback the async ServiceCallback to handle successful and failed responses.
     * @return the {@link ServiceCall} object
     */
    ServiceCall<Void> putBase64UrlEncodedAsync(byte[] stringBody, final ServiceCallback<Void> serviceCallback);

    /**
     * Put value that is base64url encoded.
     *
     * @param stringBody the Base64Url value
     * @return the {@link ServiceResponse} object if successful.
     */
    Observable<Void> putBase64UrlEncodedAsync(byte[] stringBody);

    /**
     * Put value that is base64url encoded.
     *
     * @param stringBody the Base64Url value
     * @return the {@link ServiceResponse} object if successful.
     */
    Observable<ServiceResponse<Void>> putBase64UrlEncodedWithServiceResponseAsync(byte[] stringBody);

    /**
     * Get null value that is expected to be base64url encoded.
     *
     * @return the byte[] object if successful.
     */
    byte[] getNullBase64UrlEncoded();

    /**
     * Get null value that is expected to be base64url encoded.
     *
     * @param serviceCallback the async ServiceCallback to handle successful and failed responses.
     * @return the {@link ServiceCall} object
     */
    ServiceCall<byte[]> getNullBase64UrlEncodedAsync(final ServiceCallback<byte[]> serviceCallback);

    /**
     * Get null value that is expected to be base64url encoded.
     *
     * @return the observable to the byte[] object
     */
    Observable<byte[]> getNullBase64UrlEncodedAsync();

    /**
     * Get null value that is expected to be base64url encoded.
     *
     * @return the observable to the byte[] object
     */
    Observable<ServiceResponse<byte[]>> getNullBase64UrlEncodedWithServiceResponseAsync();

}
