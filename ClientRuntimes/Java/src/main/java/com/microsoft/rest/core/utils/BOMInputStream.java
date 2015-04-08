/**
 *
 * Copyright (c) Microsoft Corporation. All rights reserved.
 * Licensed under the MIT License. See License.txt in the project root for license information.
 *
 */

package com.microsoft.rest.core.utils;

import java.io.IOException;
import java.io.InputStream;
import java.io.PushbackInputStream;

public class BOMInputStream extends InputStream {
    /**
     * Constructs a new <code>BOMInputStream</code>.
     * 
     * @param inputStream an <code>InputStream</code>.
     * 
     */
    public BOMInputStream(final InputStream inputStream) throws  NullPointerException,
                                                                        IOException {
      if (inputStream == null) {
          throw new NullPointerException();
      }
        
      pushbackInputStream = new PushbackInputStream(inputStream, 4);

      final byte [] bom = new byte[4];
      final int read = pushbackInputStream.read(bom);

      switch(read) {
          case 4:
              if ((bom[0] == (byte) 0xFF)
               && (bom[1] == (byte) 0xFE)
               && (bom[2] == (byte) 0x00)
               && (bom[3] == (byte) 0x00)) {
                  this.bom = BOM.UTF_32_LE;
                  break;
              }
              else
              if ((bom[0] == (byte) 0x00)
               && (bom[1] == (byte) 0x00)
               && (bom[2] == (byte) 0xFE)
               && (bom[3] == (byte) 0xFF)) {
                  this.bom = BOM.UTF_32_BE;
                  break;
              }

          case 3:
            if ((bom[0] == (byte) 0xEF)
             && (bom[1] == (byte) 0xBB)
             && (bom[2] == (byte) 0xBF)) {
              this.bom = BOM.UTF_8;
              break;
            }

          case 2:
              if ((bom[0] == (byte) 0xFF)
               && (bom[1] == (byte) 0xFE)) {
                  this.bom = BOM.UTF_16_LE;
                  break;
              }
              else if ((bom[0] == (byte) 0xFE)
                    && (bom[1] == (byte) 0xFF)) {
                  this.bom = BOM.UTF_16_BE;
                  break;
              }

          default:
              this.bom = BOM.NONE;
              break;
        }

        if (read > 0) {
            // If bytes read were not from a BOM, unread them.
            pushbackInputStream.unread(bom, 0, read);
        }

        if (this.bom != BOM.NONE) {
            pushbackInputStream.skip(this.bom.bytes.length);
        }
    }

    /**
     * {@inheritDoc}
     */
    public int read() throws IOException {
        return pushbackInputStream.read();
    }

    /**
     * {@inheritDoc}
     */
    public int read(final byte [] b) throws  IOException,
                                            NullPointerException {
        return pushbackInputStream.read(b, 0, b.length);
    }

    /**
     * {@inheritDoc}
     */
    public int read(final byte [] b,
                    final int off,
                    final int len) throws IOException,
                                          NullPointerException {
        return pushbackInputStream.read(b, off, len);
    }

    /**
     * {@inheritDoc}
     */
    public long skip(final long n) throws IOException {
        return pushbackInputStream.skip(n);
    }

    /**
     * {@inheritDoc}
     */
    public int available() throws IOException {
        return pushbackInputStream.available();
    }

    /**
     * {@inheritDoc}
     */
    public void close() throws IOException {
        pushbackInputStream.close();
    }

    /**
     * {@inheritDoc}
     */
    public synchronized void mark(final int readlimit) {
        pushbackInputStream.mark(readlimit);
    }

    /**
     * {@inheritDoc}
     */
    public synchronized void reset() throws IOException {
        pushbackInputStream.reset();
    }

    /**
     * {@inheritDoc}
     */
    public boolean markSupported() {
        return pushbackInputStream.markSupported();
    }

    private final PushbackInputStream pushbackInputStream;
    private final BOM bom;
    
    public static final class BOM {
        /**
         * NONE.
         */
        public static final BOM NONE = new BOM(new byte[] {}, "NONE");

        /**
         * UTF-8 BOM (EF BB BF).
         */
        public static final BOM UTF_8 = new BOM(new byte[] {(byte) 0xEF,
                                                            (byte) 0xBB,
                                                            (byte) 0xBF },
                                                "UTF-8");

        /**
         * UTF-16, little-endian (FF FE).
         */
        public static final BOM UTF_16_LE = new BOM(new byte[] {(byte) 0xFF,
                                                                (byte) 0xFE },
                                                    "UTF-16 little-endian");

        /**
         * UTF-16, big-endian (FE FF).
         */
        public static final BOM UTF_16_BE = new BOM(new byte[] {(byte) 0xFE,
                                                                (byte) 0xFF },
                                                    "UTF-16 big-endian");

        /**
         * UTF-32, little-endian (FF FE 00 00).
         */
        public static final BOM UTF_32_LE = new BOM(new byte[] {(byte) 0xFF,
                                                                (byte) 0xFE,
                                                                (byte) 0x00,
                                                                (byte) 0x00 },
                                                    "UTF-32 little-endian");

        /**
         * UTF-32, big-endian (00 00 FE FF).
         */
        public static final BOM UTF_32_BE = new BOM(new byte[] {(byte) 0x00,
                                                                (byte) 0x00,
                                                                (byte) 0xFE,
                                                                (byte) 0xFF },
                                                    "UTF-32 big-endian");

        /**
         * Returns a <code>String</code> representation of this <code>BOM</code>
         * value.
         */
        public String toString() {
            return description;
        }

        /**
         * Returns the bytes corresponding to this <code>BOM</code> value.
         */
        public byte[] getBytes() {
            final byte[] result = new byte[bytes.length];
            System.arraycopy(bytes, 0, result, 0, bytes.length);
            return result;
        }

        private BOM(final byte [] bom, final String description) {
            this.bytes = bom;
            this.description = description;
        }

        private final byte [] bytes;
        private final String description;
    }
}