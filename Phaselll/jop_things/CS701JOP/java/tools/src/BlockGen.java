/*
  This file is part of JOP, the Java Optimized Processor
    see <http://www.jopdesign.com/>

  Copyright (C) 2004, Ed Anuff (ed@anuff.com)

  This program is free software: you can redistribute it and/or modify
  it under the terms of the GNU General Public License as published by
  the Free Software Foundation, either version 3 of the License, or
  (at your option) any later version.

  This program is distributed in the hope that it will be useful,
  but WITHOUT ANY WARRANTY; without even the implied warranty of
  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  GNU General Public License for more details.

  You should have received a copy of the GNU General Public License
  along with this program.  If not, see <http://www.gnu.org/licenses/>.
*/
import java.io.*;
import java.util.*;

/**
 * Generate a memory module using one or more BlockRams with the appropriate
 * address and data decoding and pre-initialization.
 * 
 * Can use either a text file with hex values or Altera-style MIF file for
 * initialization data.
 *
 * @author Ed Anuff (ed@anuff.com)
 *
 */
public class BlockGen {
	
	static String build_date = "Feb 2 2004 4:01 PM PST";
	int depth = 512;
	int width = 8;
	int block = 4096;
	String src_filename = "";
	String dst_filename = "";
	File src_file;
	String module_name = "";
	String dst_dir = "";
	boolean init_ram = false;
	boolean preserve_depth = false;
	
	public BlockGen(String[] args) {
		processOptions(args);
	}
	
	public void process() {
		try {
			
			if (!stringEmpty(src_filename)) {
				src_file = new File(src_filename);
				dst_dir = src_file.getParent();
			}
			if (stringEmpty(module_name) && (src_file.getName().indexOf('.') > 0)) {
				module_name = src_file.getName().substring(0, src_file.getName().indexOf('.'));
			}
			if (stringEmpty(module_name)) module_name = "ram";
			if (stringEmpty(dst_filename)) dst_filename = dst_dir + File.separator + module_name + ".vhd";
			
			System.out.println("BlockRam Generator");
			System.out.println("Module: " + module_name);
			
			String binary_string = "";
			
			if (!stringEmpty(src_filename)) {
				File file = new File(src_filename);
				if (!file.exists()) {
					System.out.println("Input file not found: " + src_filename);
					System.exit(-1);
				}
				init_ram = true;
				if (src_filename.endsWith(".mif"))
					binary_string = parseMifFile();
				else
					binary_string = parseTextFile();
			}
			
			if (init_ram) {
				System.out.println("Input file: " + src_filename);
			}
			else {
				System.out.println("No input file for pre-initialization specified.");
			}
			System.out.println("Output file: " + dst_filename);
			
			
			PrintWriter pw = new PrintWriter(new FileWriter(dst_filename));
			
			int bitcount = width * depth;
			if (init_ram) bitcount = binary_string.length();
			int block_bitcount = width * depth;
			
			if (bitcount > block_bitcount) {
				System.out.println("Data (" + bitcount + " bits) is larger than BlockRam capacity at the specified width and depth.");
				System.exit(1);
			}
			
			if ((bitcount % width) != 0) {
				System.out.println("Input data not bit aligned to the specified width.");
				System.exit(1);
			}
			
			int block_count = 1;
			int port_width = 1;
			int max_port_width = 16;
			boolean ramb16 = block == 16384; 
			if (ramb16) max_port_width = 32;
			
			while (port_width <= max_port_width) {
				if (depth <= (block / port_width)) {
					block_count = width / port_width;
				}
				if (depth * 2 > (block / port_width)) {
					break;
				}
				port_width = port_width * 2;
			}
			
			if (port_width > max_port_width) port_width = max_port_width;
			
			if (block_count < 1) block_count = 1;
			
			int pl = 0;
			int ph = port_width - 1;
			int ah = Integer.toBinaryString((block / port_width) - 1).length() - 1;
			int wh = width - 1;
			int pbh = 0;
			int cpw = port_width;
			if (port_width == 16) {
				pbh = 1;
			}
			else if (port_width == 32) {
				pbh = 3; 
			}
			String pbhi = zero(pbh + 1);
			if (ramb16) cpw = port_width + pbh + 1;
			boolean pad_addr = false;
			int mah = ah;
			String addr_prefix = "";
			if (preserve_depth) {
				mah = Integer.toBinaryString(depth - 1).length() - 1;
				if (mah < ah) {
					pad_addr = true;
					addr_prefix = "p_";
				}
			}
			
			String rtype = "RAMB4";
			String rsta = "RSTA";
			String rstb = "RSTB";
			if (ramb16) {
				rtype = "RAMB16";
				rsta = "SSRA";
				rstb = "SSRB";
			}
			
			pw.println("--");
			pw.println("-- " + (new File(dst_filename)).getName());
			pw.println("--");
			pw.println("-- Generated by BlockGen");
			pw.println("-- " + (new Date()));
			pw.println("--");
			if (ramb16) pw.println("-- This module will synthesize on Spartan3 and Virtex2/2Pro/2ProX devices.");
			else pw.println("-- This module will synthesize on Spartan2/2E and Virtex/E devices.");
			pw.println("--");
			pw.println();
			
			pw.println("library IEEE;");
			pw.println("use IEEE.std_logic_1164.all;");
			pw.println("use IEEE.std_logic_arith.all;");
			pw.println("use IEEE.std_logic_unsigned.all;");
			pw.println("library unisim;");
			pw.println("use unisim.vcomponents.all;");
			pw.println();
			
			pw.println("entity " + module_name + " is");
			pw.println("\tport (");
			pw.println("\t\ta_rst  : in std_logic;");
			pw.println("\t\ta_clk  : in std_logic;");
			pw.println("\t\ta_en   : in std_logic;");
			pw.println("\t\ta_wr   : in std_logic;");
			pw.println("\t\ta_addr : in std_logic_vector(" + mah + " downto 0);");
			pw.println("\t\ta_din  : in std_logic_vector(" + wh + " downto 0);");
			pw.println("\t\ta_dout : out std_logic_vector(" + wh + " downto 0);");
			pw.println("\t\tb_rst  : in std_logic;");
			pw.println("\t\tb_clk  : in std_logic;");
			pw.println("\t\tb_en   : in std_logic;");
			pw.println("\t\tb_wr   : in std_logic;");
			pw.println("\t\tb_addr : in std_logic_vector(" + mah + " downto 0);");
			pw.println("\t\tb_din  : in std_logic_vector(" + wh + " downto 0);");
			pw.println("\t\tb_dout : out std_logic_vector(" + wh + " downto 0)");
			pw.println("\t);");
			pw.println("end " + module_name + ";");
			pw.println();
			
			pw.println("architecture rtl of " + module_name + " is");
			pw.println();
			
			pw.println("\tcomponent " + rtype + "_S" + cpw + "_S" + cpw);
			pw.println("\t\tport (");
			pw.println("\t\t\tDIA    : in std_logic_vector (" + ph + " downto 0);");
			pw.println("\t\t\tDIB    : in std_logic_vector (" + ph + " downto 0);");
			pw.println("\t\t\tENA    : in std_logic;");
			pw.println("\t\t\tENB    : in std_logic;");
			pw.println("\t\t\tWEA    : in std_logic;");
			pw.println("\t\t\tWEB    : in std_logic;");
			pw.println("\t\t\t" + rsta + "   : in std_logic;");
			pw.println("\t\t\t" + rstb + "   : in std_logic;");
			if (ramb16 && (port_width >= 8)) {
				pw.println("\t\t\tDIPA   : in std_logic_vector (" + pbh + " downto 0);");
				pw.println("\t\t\tDIPB   : in std_logic_vector (" + pbh + " downto 0);");
				pw.println("\t\t\tDOPA   : out std_logic_vector (" + pbh + " downto 0);");
				pw.println("\t\t\tDOPB   : out std_logic_vector (" + pbh + " downto 0);");
			}
			pw.println("\t\t\tCLKA   : in std_logic;");
			pw.println("\t\t\tCLKB   : in std_logic;");
			pw.println("\t\t\tADDRA  : in std_logic_vector (" + ah + " downto 0);");
			pw.println("\t\t\tADDRB  : in std_logic_vector (" + ah + " downto 0);");
			pw.println("\t\t\tDOA    : out std_logic_vector (" + ph + " downto 0);");
			pw.println("\t\t\tDOB    : out std_logic_vector (" + ph + " downto 0)");
			pw.println("\t\t); ");
			pw.println("\tend component;");
			pw.println();
			
			if (init_ram) {
				pw.println("\tattribute INIT: string;");
				int attribute_count = block / 256;
				for (int i = 0; i < attribute_count; i ++) {
					pw.println("\tattribute INIT_" + toHex(i, 2) + ": string;");
				}
				pw.println();
				
				for (int block_i = 0; block_i < block_count; block_i ++) {
					String block_bits = getBlockBits(binary_string, port_width, width, block_i);
					block_bits = padTrailingBitsToBlockSize(block_bits, block);
					String[] init_string = split(block_bits, 256);
					
					for (int i = 0; i < init_string.length; i++ ) {
						String init_hex = longBinaryStringToHex(reverse(init_string[i], port_width));
						pw.println("\tattribute INIT_" + toHex(i, 2) + " of cmp_ram_" + block_i + ": label is \"" + init_hex + "\";");
					}
					
					pw.println();
					
				}
			}
			
			if (pad_addr) {
				pw.println("\tsignal p_a_addr : std_logic_vector (" + ah + " downto 0);");
				pw.println("\tsignal p_b_addr : std_logic_vector (" + ah + " downto 0);");
				pw.println();
			}
			
			pw.println("begin");
			pw.println();
			
			if (pad_addr) {
				pw.println("\tp_a_addr <= \"" + zero(ah - mah) + "\" & a_addr;");
				pw.println("\tp_b_addr <= \"" + zero(ah - mah) + "\" & b_addr;");
				pw.println();
			}
			
			for (int block_i = 0; block_i < block_count; block_i ++) {
				pw.println("\tcmp_ram_" + block_i + " : " + rtype + "_S" + cpw + "_S" + cpw);
				pw.println("\t\tport map (");
				pw.println("\t\t\tWEA => a_wr,");
				pw.println("\t\t\tWEB => b_wr,"); 
				pw.println("\t\t\tENA => a_en,"); 
				pw.println("\t\t\tENB => b_en,"); 
				pw.println("\t\t\t" + rsta + " => a_rst,"); 
				pw.println("\t\t\t" + rstb + " => b_rst,"); 
				if (ramb16 && (port_width >= 8)) {
					pw.println("\t\t\tDIPA => \"" + pbhi + "\",");
					pw.println("\t\t\tDIPB => \"" + pbhi + "\",");
					pw.println("\t\t\tDOPA => open,");
					pw.println("\t\t\tDOPB => open,");
				}
				pw.println("\t\t\tCLKA => a_clk,");  
				pw.println("\t\t\tCLKB => b_clk,");
				pw.println("\t\t\tDIA => a_din(" + ph + " downto " + pl + "),"); 
				pw.println("\t\t\tADDRA => " + addr_prefix + "a_addr,"); 
				pw.println("\t\t\tDOA => a_dout(" + ph + " downto " + pl + "),");
				pw.println("\t\t\tDIB => b_din(" + ph + " downto " + pl + "),"); 
				pw.println("\t\t\tADDRB => " + addr_prefix + "b_addr,"); 
				pw.println("\t\t\tDOB => b_dout(" + ph + " downto " + pl + ")");
				pw.println("\t\t);");
				pw.println();
				
				pl += port_width;
				ph += port_width;

			}
			
			pw.println("end rtl;");
			
			pw.close();

			System.out.print(block_count + " block");
			if (block_count > 1) System.out.print("s");
			System.out.println(" used (" + block + " bits/block).");
			System.out.println("Done.");
			
		} catch (IOException e) {
			System.out.println(e.getMessage());
			System.exit(-1);
		}
		
	}
	
	private static final int SEEK_GENERAL = 0;
	private static final int SEEK_ADDR = 1;
	private static final int SEEK_DATA = 2;
	
	/**
	 * Parse a file in Altera MIF file format.
	 * 
	 * @return String containing binary data
	 * @throws IOException
	 */
	
	public String parseMifFile() throws IOException {
		
		FileReader fr = new FileReader(src_filename);
		StreamTokenizer st = new StreamTokenizer(fr);
		
		st.resetSyntax();
		st.eolIsSignificant(true);
		st.slashStarComments(true);
		st.slashSlashComments(true);
		st.lowerCaseMode(true);
		st.commentChar('%');
		st.commentChar('-');
		st.wordChars('0', '9');
		st.wordChars('a', 'z');
		st.wordChars('A', 'Z');
		st.wordChars('_', '_');
		st.wordChars('[', '[');
		st.wordChars(']', ']');
		st.wordChars('.', '.');
		st.whitespaceChars(0, ' ');
		
		int state = SEEK_GENERAL;
		int address_radix = 16;
		int data_radix = 16;
		int addr = 0;
		int addr_range_lo = 0;
		int addr_range_hi = 0;
		boolean is_addr_range = false;
		
		long[] mem = null;
		
		while (st.nextToken() != StreamTokenizer.TT_EOF)
		{
			if (state == SEEK_GENERAL) {
				if ("width".equalsIgnoreCase(st.sval)) {
					st.nextToken();
					st.nextToken();
					if (!stringEmpty(st.sval)) {
						width = Integer.parseInt(st.sval);
					}
				}
				else if ("depth".equalsIgnoreCase(st.sval)) {
					st.nextToken();
					st.nextToken();
					if (!stringEmpty(st.sval)) {
						depth = Integer.parseInt(st.sval);
						mem = new long[depth];
					}
				}
				else if ("address_radix".equalsIgnoreCase(st.sval)) {
					st.nextToken();
					st.nextToken();
					if ("bin".equalsIgnoreCase(st.sval)) address_radix = 2;
					else if ("dec".equalsIgnoreCase(st.sval)) address_radix = 10;
					else if ("hex".equalsIgnoreCase(st.sval)) address_radix = 16;
					else if ("oct".equalsIgnoreCase(st.sval)) address_radix = 8;
				}
				else if ("data_radix".equalsIgnoreCase(st.sval)) {
					st.nextToken();
					st.nextToken();
					if ("bin".equalsIgnoreCase(st.sval)) data_radix = 2;
					else if ("dec".equalsIgnoreCase(st.sval)) data_radix = 10;
					else if ("hex".equalsIgnoreCase(st.sval)) data_radix = 16;
					else if ("oct".equalsIgnoreCase(st.sval)) data_radix = 8;
				}
				else if ("begin".equalsIgnoreCase(st.sval)) {
					state = SEEK_ADDR;
				}
			}
			else if ((state == SEEK_ADDR) && (st.ttype == StreamTokenizer.TT_WORD)) {
				if (!stringEmpty(st.sval)) {
					if ("end".equalsIgnoreCase(st.sval)) {
						break;
					}
					else if (st.sval.startsWith("[")) {
						is_addr_range = true;
						addr_range_lo = Integer.parseInt(st.sval.substring(1, st.sval.indexOf('.')), address_radix);
						addr_range_hi = Integer.parseInt(st.sval.substring(st.sval.lastIndexOf('.') + 1, st.sval.length() - 1), address_radix);
					}
					else {
						is_addr_range = false;
						addr = Integer.parseInt(st.sval, address_radix);
					}
					state = SEEK_DATA;
				}
			}
			else if ((state == SEEK_DATA) && (st.ttype == StreamTokenizer.TT_EOL)) {
				state = SEEK_ADDR;
			}
			else if ((state == SEEK_DATA) && (st.ttype == StreamTokenizer.TT_WORD)) {
				if (!stringEmpty(st.sval)) {
					long data = Long.parseLong(st.sval, data_radix);
					if (is_addr_range) {
						for (addr = addr_range_lo; addr <= addr_range_hi; addr++) {
							if (addr >= 0 && addr < mem.length) mem[addr] = data;
							else {
								System.out.println("Warning: Data at address " + addr + " is outside the range of the specified depth.");
							}
						}
					}
					else {
						if (addr >= 0 && addr < mem.length) mem[addr] = data;
						else {
							System.out.println("Warning: Data at address " + addr + " is outside the range of the specified depth.");
						}
					}
					addr++;
				}
			}			
		}
		
		fr.close();
		
		StringBuffer binary_buffer = new StringBuffer();
		
		for (int i = 0; i < mem.length; i ++) {
			binary_buffer.append(toBinary(mem[i], width));
		}
		
		return binary_buffer.toString();
	}
	
	/**
	 * Brute force parse of a text file to extract hex data.
	 * Good for files that only contain the desired hex data and whitespace or
	 * delimeters such as commas or semicolons.
	 * 
	 * @return String containing binary data.
	 * @throws IOException
	 */
		
	public String parseTextFile() throws IOException {
		
		FileReader fr = new FileReader(src_filename);
		BufferedReader br = new BufferedReader(fr);
		
		StringBuffer hex_buffer = new StringBuffer();
		
		String line = br.readLine();
		
		while (line != null) {
			
			line = line.toUpperCase();
			line = findAndReplace(line, "0X", ""); 
			line = endBefore(line, "/"); 
			line = filterNonHexDigits(line);
			if (!stringEmpty(line)) {
				hex_buffer.append(line);
			}
			
			line = br.readLine();
		}
		
		br.close();
		
		return longHexStringToBinary(hex_buffer.toString());
	}
	
	/**
	 * Test for whether a string is null or of zero length.
	 * 
	 * @param str string to test
	 * @return true if string is empty or null
	 */

	public static boolean stringEmpty(String str) {
		if (str == null) return true;
		if (str.length() == 0) return true;
		return false;
	}
	
	/**
	 * Given a string with binary data, divide it into words of length <code>w</code> and
	 * subdivide it based on the port width in <code>p_w</code> and then select which of the subdivisions
	 * to extract given the value in <code>b_c</code>.
	 */
	
	public static String getBlockBits(String input, int p_w, int w, int b_c) {
		StringBuffer output = new StringBuffer();
		int n_p = w / p_w;
		b_c = n_p - b_c - 1;
		for (int i = 0; i < input.length(); i += w) {
			int s = i + (b_c * p_w);
			int e = s + p_w;
			output.append(input.substring(s, e));
		}
		return output.toString();
	}
	
	/**
	 * Reverse the input string by extracting blocks of length len and reordering them.
	 * For example, if <code>len</code> equals <code>2</code> and <code>input</code> is
	 * <code>A1B2C3D4E5</code>, then the return value will be <code>E5D4C3B2A1</code>.
	 * @param input string to reverse
	 * @param len length of blocks within string
	 * @return reversed string
	 */
	
	public static String reverse(String input, int len) {
		StringBuffer output = new StringBuffer();
		int i = input.length() - len;
		while (i >= 0) {
			output.append(input.substring(i, i + len));
			i -= len;
		}
		return output.toString();
	}
	
	/**
	 * Split the input string into an array of strings of length <code>count</code>
	 * @param input string to split
	 * @param count character count to split at
	 * @return array of strings
	 */
	
	public static String[] split(String input, int count) {
		ArrayList list = new ArrayList();
		int i = 0;
		while (i < input.length()) {
			list.add(input.substring(i, Math.min(i + count, input.length())));
			i += count;
		}
		return (String[])list.toArray(new String[]{});
	}
	
	/**
	 * Replace all instances of string <code>find</code> in the input string with string
	 * <code>replace</code>.
	 * @param input string to search
	 * @param find string to search for
	 * @param replace string to replace with
	 * @return processed string
	 */

	public static String findAndReplace(String input, String find, String replace) {
		String output = input;
		int idx;
		while ((idx = output.indexOf(find)) != -1) {
			output = output.substring(0, idx) + replace + output.substring(idx+find.length());
		}
		return output;
		
	}
	
	/**
	 * Input parameter <code>terms<code> containst a set of <code>find</code> and <code>replace</code> pairs to 
	 * apply to the input string.
	 * @param input string to search
	 * @param terms hashmap of find and replace pairs
	 * @return processed string
	 */

	public static String findAndReplace(String input, HashMap terms) {
		String output = input;
		for (Iterator i = terms.keySet().iterator(); i.hasNext();) {
			String find = i.next().toString();
			String replace = terms.get(find).toString();
			
			int idx;
			while ((idx = output.indexOf(find)) != -1) {
				output = output.substring(0, idx) +
				replace +
				output.substring(idx+find.length());
			}
			//Pattern p = Pattern.compile(find, Pattern.CASE_INSENSITIVE);
			//Matcher m = p.matcher(output);
			//output = m.replaceAll(replace);
			
		}
		return output;
	}
	
	/**
	 * Terminate the input string at the first instance of the string passed as <code>terminator</code>.
	 * @param input string to terminate
	 * @param terminator string to find in the input string and to terminate input before
	 * @return terminated string
	 */
	
	public static String endBefore(String input, String terminator) {
		String output = input;
		int idx;
		if ((idx = output.indexOf(terminator)) != -1) {
			output = output.substring(0, idx);
		}
		return output;
		
	}
	
	/**
	 * Remove any characters that are not 0 to 9 or A to F (case sensitive).
	 * 
	 * @param input string to process for non-hex characters
	 * @return string with non-hex characters removed
	 */
	
	public static String filterNonHexDigits(String input) {
		StringBuffer output = new StringBuffer();
		for (int i = 0; i < input.length(); i ++) {
			char c = input.charAt(i);
			if (Character.isDigit(c) || ((c >= 'A') && (c <= 'F'))) {
				output.append(c);
			}
		}
		return output.toString();
		
	}
	
	/**
	 * Read a file into a string.
	 * 
	 * @param file file to read
	 * @return contents of file
	 */
	
	public static String readFileContents(File file) {
		String contents = null;
		try {
			FileInputStream fis = new FileInputStream(file);
			byte[] data = new byte[(int)file.length()];
			int r = fis.read(data);
			contents = new String(data, 0, r);
		}
		catch (Exception e) {
		}
		return contents;
	}
	
	/**
	 * Read a file into a string.
	 * 
	 * @param file_name filename of file to read
	 * @return contents of file
	 */
	
	public static String readFileContents(String file_name) {
		File file = new File(file_name);
		return readFileContents(file);
	}
	
	/**
	 * Convert an integer into a hex string with correct zero padding for word aligment.
	 * 
	 * @param i integer value to convert
	 * @param word word size to align hex return value to
	 * @return hex return value
	 */
	
	public static String toHex(int i, int word) {
		String result = Integer.toHexString(i);
		if ((result.length() % word) != 0) result = zero(word - (result.length() % word)) + result;
		return result;
	}
	
	/**
	 * Convert an long integer into a binary string with correct zero padding for word aligment.
	 * 
	 * @param n long integer value to convert
	 * @param word word size to align hex return value to
	 * @return hex return value
	 */
	
	public static String toBinary(long n, int word) {
		String result = Long.toBinaryString(n);
		if ((result.length() % word) != 0) result = zero(word - (result.length() % word)) + result;
		return result;
	}
	
	/**
	 * Generate a string of zeros of the specified count
	 * @param count number of zeroes to generate
	 * @return string with the specified number of zeros
	 */
	
	public static String zero(int count) {
		StringBuffer result = new StringBuffer();
		while (result.length() < count) result.append('0');
		return result.toString();
	}
	
	/**
	 * Convert a hex string into a binary string with correct zero padding for word aligment.
	 * Use for hex string of less than 8 characters.
	 * @param hex input hex string
	 * @param word word size to align binary return value to 
	 * @return binary return value
	 */
	
	public static String hexToBinary(String hex, int word) {
		int i = Integer.parseInt(hex, 16);
		return toBinary(i, word);
	}
	
	/**
	 * Convert a hex string into a binary string with correct zero padding for word aligment.
	 * Use for hex string of 8 or more characters.
	 * @param hex input hex string
	 * @return binary return value
	 */
	
	public static String longHexStringToBinary(String hex) {
		StringBuffer output = new StringBuffer();
		for (int i = 0; i < hex.length(); i++) {
			String h = hex.substring(i, i + 1);
			output.append(hexToBinary(h, 4));
		}
		return output.toString();
	}
	
	/**
	 * Convert a binary string into a hex string.
	 * 
	 * @param input binary string
	 * @return hex string
	 */

	public static String longBinaryStringToHex(String input) {
		StringBuffer output = new StringBuffer();
		for (int i = 0; i < input.length(); i += 4) {
			String nibble = input.substring(i, i + 4);
			int n = 0;
			if (nibble.charAt(3) == '1') n += 1;
			if (nibble.charAt(2) == '1') n += 2;
			if (nibble.charAt(1) == '1') n += 4;
			if (nibble.charAt(0) == '1') n += 8;
			output.append(Integer.toHexString(n));
		}
		return output.toString();
	}
	
	/**
	 * Given a binary string of a length less that <code>size</code>, append
	 * trailing zeroes to pad it to the specified size.
	 * @param input the input string
	 * @return string with the correct length
	 */
	
	public static String padTrailingBitsToBlockSize(String input, int size) {
		StringBuffer output = new StringBuffer(input);
		if (output.length() < size) output.append(zero(size - output.length()));
		return output.toString();
	}
	
	/**
	 * Process the command line parameters
	 * 
	 * @param clist command line parameters passed to main() method
	 * @return true if options processed correctly
	 */

	public boolean processOptions( String clist[] ){
		boolean success = true;
		
		for( int i = 0; i < clist.length; i++ ){
			if ( clist[i].equals("-w")  ){
				width =  Integer.parseInt(clist[ ++i ]);
			} else if ( clist[i].equals("-d")  ){
				depth =  Integer.parseInt(clist[ ++i ]);
			} else if ( clist[i].equals("-b")  ){
				block =  Integer.parseInt(clist[ ++i ]);
			} else if ( clist[i].equals("-m")  ){
				module_name = clist[ ++i ];
			} else if ( clist[i].equals("-o")  ){
				dst_dir = clist[ ++i ];
			} else if ( clist[i].equals("-pd")  ){
				preserve_depth = true;
			} else if ( clist[i].startsWith("-")  ){
				printUsage();
				System.out.println("Unknown parameter: " + clist[i]);
				System.exit(-1);
			} else { 
				if (stringEmpty(src_filename)) src_filename = clist[i];
				else dst_filename = clist[i];
			}
		}
		
		return success;
	}
	
	public static void printUsage() {
		System.out.println("BlockRAM VHDL Module Generator");
		System.out.println("By Ed Anuff <ed@anuff.com>");
		System.out.println("Version built: " + build_date);
		System.out.println();
		System.out.println("Usage:");
		System.out.println("java BlockGen [-w #] [-d #] [-b #] [-m name] [-o dir] [-pd] [src [dst]]");
		System.out.println();
		System.out.println("Generates a memory module in VHDL using Xilinx Synchronous Block RAM with");
		System.out.println("the given parameters.");
		System.out.println();
		System.out.println("Input file should be in Altera MIF (.mif) format or be a text file with");
		System.out.println("hex data that can be extracted.");
		System.out.println();
		System.out.println("If no input file is specified, an uninitialized memory module will be");
		System.out.println("generated.");
		System.out.println();
		System.out.println("Parameters:");
		System.out.println(" -w  : RAM data width in # of bits to a data word");
		System.out.println(" -d  : RAM address depth in # of words");
		System.out.println(" -b  : Size of Block RAM for the target device - ");
		System.out.println("       4096 for Spartan2/2E/Virtex/E");
		System.out.println("       16384 for Spartan3/Virtex2/2Pro/2ProX");
		System.out.println(" -m  : Name of module generated");
		System.out.println(" -o  : Output directory");
		System.out.println(" -pd : Preserve depth - Use specified address depth even");
		System.out.println("       if larger address range is available in the Block RAM used.");
		System.out.println();
	}
	
	public static void main(String[] args) {
		if (args.length < 1) {
			printUsage();
			System.exit(-1);
		}

		BlockGen bgen = new BlockGen(args);
		bgen.process();
		
		//System.out.println(hexToBinary("A3", 8));
		
	}
}