require 'open3'

class Command
  def cmd
    "./ood_conda_env.sh"
  end

  def create_table
    # read all conda envs
    conda_envs = File.readlines(ENV['HOME']+'/ondemand/conda-env-list.txt').map(&:chomp)
    # read Jupyter conda envs
    jupyter_envs = File.readlines(ENV['HOME']+'/ondemand/conda-jupyter-env-list.txt').map(&:chomp)
    # read R conda envs
    r_envs = File.readlines(ENV['HOME']+'/ondemand/conda-r-env-list.txt').map(&:chomp)
    str = "<table>"
    str = str + "<tr>"
    str = str + " <th>Conda Environment</th>"
    str = str + " <th>With Jupyter</th>"
    str = str + " <th>With R</th>"
    str = str + "</tr>"
    conda_envs.each{ |x|
    str = str + "<tr>"
    str = str + "<td>"
    str = str +  x
    str = str + "</td>"
    if jupyter_envs.any?{|s| s.include?(x)}
    str = str + "<td style=\"color:green\">"
    str = str +  "yes"
    else
    str = str + "<td style=\"color:red\">"
    str = str + "no"
    end
    str = str + "</td>"
    if r_envs.include?(x)
    str = str + "<td style=\"color:green\">"
    str = str +  "yes"
    else
    str = str + "<td style=\"color:red\">"
    str = str + "no"
    end
    str = str + "</td>"
    str = str + "</tr>"
    }
    str = str + "</table>"
    return str
  end

  def write_table
    # read all conda envs
    conda_envs = File.readlines(ENV['HOME']+'/ondemand/conda-env-list.txt').map(&:chomp)
    jupyter_envs = File.readlines(ENV['HOME']+'/ondemand/conda-jupyter-env-list.txt').map(&:chomp)
    r_envs = File.readlines(ENV['HOME']+'/ondemand/conda-r-env-list.txt').map(&:chomp)
    puts conda_envs
    # read Jupyter conda envs

    # read R conda envs
    puts"<table>"
    puts"<tr>"
    puts" <th>Conda Name</th>"
    puts" <th>has Jupyter</th>"
    puts" <th>has R</th>"
    puts"</tr>"
    conda_envs.each{ |x|
    puts"<tr>"
    puts"<td>"
    puts x
    puts"</td>"
    puts"<td>"
    if jupyter_envs.any?{|s| s.include?(x)}
    puts "yes"
    else
    puts "no"
    end
    puts"</td>"
    puts"<td>"
    if r_envs.include?(x)
    puts "yes"
    else
    puts "no"
    end
    puts"</td>"
    puts"</tr>"
    }
    puts"</table>"
    puts "table created"
  end
  def exec
    stdout_str, stderr_str, status = Open3.capture3(cmd)
    if status.success?
      table = create_table  
    else
      error = "Command '#{cmd}' exited with error: #{stderr_str}"
    end

    [table, error] 
  end
end

