require 'rdoc/markup/simple_markup'
require 'rdoc/markup/simple_markup/to_flow'
require 'rdoc/ri/ri_formatter'
require 'rdoc/ri/ri_options'

module Readme

  # Display usage information from the comment at the top of
  # the file. String arguments identify specific sections of the
  # comment to display. An optional integer first argument
  # specifies the exit status  (defaults to 0)

  def Readme.usage(*args)
    exit_code = 0

    if args.size > 0
      status = args[0]
      if status.respond_to?(:to_int)
        exit_code = status.to_int
        args.shift
      end
    end

    # display the usage and exit with the given code
    usage_no_exit(*args)
    exit(exit_code)
  end

  # Display usage
  def Readme.usage_no_exit(*args)
    # main_program_file = caller[-1].sub(/:\d+$/, '') # ruby-bitly
    main_program_file = File.join(File.dirname(__FILE__), '..', 'README.rdoc')
    
    comment = File.open(main_program_file) do |file|
      find_comment(file)
    end

    comment = comment.gsub(/^\s*#/, '')

    markup = SM::SimpleMarkup.new
    flow_convertor = SM::ToFlow.new
    
    flow = markup.convert(comment, flow_convertor)

    format = "plain"

    unless args.empty?
      flow = extract_sections(flow, args)
    end

    options = RI::Options.instance
    if args = ENV["RI"]
      options.parse(args.split)
    end
    formatter = options.formatter.new(options, "")
    formatter.display_flow(flow)
  end

  ######################################################################

  private

  # Find the first comment in the file (that isn't a shebang line)
  # If the file doesn't start with a comment, report the fact
  # and return empty string

  def Readme.gets(file)
    if (line = file.gets) && (line =~ /^#!/) # shebang
      throw :exit, find_comment(file)
    else
      line
    end
  end

  def Readme.find_comment(file)
    catch(:exit) do
      # skip leading blank lines
      0 while (line = gets(file)) && (line =~ /^\s*$/)

      comment = []
      while line # && line =~ /^\s*#/ # ruby-bitly
        comment << line
        line = gets(file)
      end

      0 while line && (line = gets(file))
      return no_comment if comment.empty?
      return comment.join
    end
  end


  #####
  # Given an array of flow items and an array of section names, extract those
  # sections from the flow which have headings corresponding to
  # a section name in the list. Return them in the order
  # of names in the +sections+ array.

  def Readme.extract_sections(flow, sections)
    result = []
    sections.each do |name|
      name = name.downcase
      copy_upto_level = nil

      flow.each do |item|
        case item
        when SM::Flow::H
          if copy_upto_level && item.level >= copy_upto_level
            copy_upto_level = nil
          else
            if item.text.downcase == name
              result << item
              copy_upto_level = item.level
            end
          end
        else
          if copy_upto_level
            result << item
          end
        end
      end
    end
  
    if result.empty?
      # puts "Note to developer: requested section(s) [#{sections.join(', ')}] not found"
      result = flow
    end
    result
  end

  #####
  # Report the fact that no doc comment count be found
  def Readme.no_comment
    $stderr.puts "No usage information available for this program"
    ""
  end
end
