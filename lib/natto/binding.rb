# coding: utf-8
module Natto

  # Module `Binding` encapsulates methods and behavior 
  # which are made available via `FFI` bindings to 
  # `mecab`.
  module Binding
    require 'ffi'
    require 'rbconfig'
    extend FFI::Library

    # String name for the environment variable used by 
    # `Natto` to indicate the exact name / full path
    # to the `mecab` library.
    MECAB_PATH = 'MECAB_PATH'.freeze
    
    # @private
    def self.included(base)
      base.extend(ClassMethods)
    end

    # Returns the name of the `mecab` library based on 
    # the runtime environment. The value of the environment
    # parameter `MECAB_PATH` is checked before this
    # function is invoked, and in the case of Windows, a
    # `LoadError` will be raised if `MECAB_PATH`
    # is _not_ set to the full path of the `mecab`
    # library.
    # @return name of the `mecab` library
    # @raise [LoadError] if MECAB_PATH environment variable is not set in Windows
    # <br/>
    # e.g., for bash on UNIX/Linux
    #
    #     export MECAB_PATH=/usr/local/lib/libmecab.so
    #
    # e.g., on Windows
    #
    #     set MECAB_PATH=C:\Program Files\MeCab\bin\libmecab.dll
    #
    # e.g., from within a Ruby program
    #
    #     ENV['MECAB_PATH']='usr/local/lib/libmecab.so'
    def self.find_library
      host_os = RbConfig::CONFIG['host_os']

      if host_os =~ /mswin|mingw/i
        raise LoadError, "Please set #{MECAB_PATH} to the full path to libmecab.dll"
      else
        'mecab'
      end
    end

    ffi_lib(ENV[MECAB_PATH] || find_library)

    # new interface
    attach_function :mecab_model_new2, [:string], :pointer
    attach_function :mecab_model_destroy, [:pointer], :void
    attach_function :mecab_model_dictionary_info, [:pointer], :pointer

    # old interface
    attach_function :mecab_new2, [:string], :pointer
    attach_function :mecab_version, [], :string
    attach_function :mecab_strerror, [:pointer],:string
    attach_function :mecab_destroy, [:pointer], :void
    attach_function :mecab_set_partial, [:pointer, :int], :void 
    attach_function :mecab_set_theta, [:pointer, :float], :void
    attach_function :mecab_set_lattice_level, [:pointer, :int], :void 
    attach_function :mecab_set_all_morphs, [:pointer, :int], :void
    attach_function :mecab_sparse_tostr, [:pointer, :string], :string
    attach_function :mecab_sparse_tonode, [:pointer, :string], :pointer
    attach_function :mecab_nbest_init, [:pointer, :string], :int
    attach_function :mecab_nbest_sparse_tostr, [:pointer, :int, :string], :string
    attach_function :mecab_nbest_next_tonode, [:pointer], :pointer
    attach_function :mecab_format_node, [:pointer, :pointer], :string
    attach_function :mecab_dictionary_info, [:pointer], :pointer

    # @private
    module ClassMethods

      def mecab_model_new2(options_str)
        Natto::Binding.mecab_model_new2(options_str)
      end
      
      def mecab_model_destroy(m_ptr)
        Natto::Binding.mecab_model_destroy(m_ptr)
      end

      def mecab_model_dictionary_info(m_ptr)
        Natto::Binding.mecab_model_dictionary_info(m_ptr)
      end
      
      # ----------------------------------------
      def mecab_new2(options_str)
        Natto::Binding.mecab_new2(options_str)
      end
      
      def mecab_version
        Natto::Binding.mecab_version
      end

      def mecab_strerror(m_ptr)
        Natto::Binding.mecab_strerror(m_ptr)
      end

      def mecab_destroy(m_ptr)
        Natto::Binding.mecab_destroy(m_ptr)
      end

      def mecab_set_partial(m_ptr, ll)
        Natto::Binding.mecab_set_partial(m_ptr, ll)
      end
      
      def mecab_set_theta(m_ptr, t)
        Natto::Binding.mecab_set_theta(m_ptr, t)
      end

      def mecab_set_lattice_level(m_ptr, ll)
        Natto::Binding.mecab_set_lattice_level(m_ptr, ll)
      end
      
      def mecab_set_all_morphs(m_ptr, am)
        Natto::Binding.mecab_set_all_morphs(m_ptr, am)
      end

      def mecab_sparse_tostr(m_ptr, str)
        Natto::Binding.mecab_sparse_tostr(m_ptr, str)
      end
      
      def mecab_sparse_tonode(m_ptr, str)
        Natto::Binding.mecab_sparse_tonode(m_ptr, str)
      end

      def mecab_nbest_next_tonode(m_ptr)
        Natto::Binding.mecab_nbest_next_tonode(m_ptr)
      end

      def mecab_nbest_init(m_ptr, str)
        Natto::Binding.mecab_nbest_init(m_ptr, str)
      end

      def mecab_nbest_sparse_tostr(m_ptr, n, str)
        Natto::Binding.mecab_nbest_sparse_tostr(m_ptr, n, str)
      end

      def mecab_nbest_next_tonode(m_ptr)
        Natto::Binding.mecab_nbest_next_tonode(m_ptr)
      end

      def mecab_format_node(m_ptr, n_ptr)
        Natto::Binding.mecab_format_node(m_ptr, n_ptr)
      end
      
      def mecab_dictionary_info(m_ptr)
        Natto::Binding.mecab_dictionary_info(m_ptr)
      end
    end
  end
end
