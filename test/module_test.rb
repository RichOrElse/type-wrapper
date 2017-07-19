require "test_helper"

class TypeWrapper::ModuleTest < Minitest::Test
  AwesomeSinging = TypeWrapper::Module.new do |mod| using mod
    def sing
      "#{name} sings #{song}"
    end

    def song
      "Everything is AWESOME!!!"
    end
  end

  def test_module_refines
    assert_kind_of Module, AwesomeSinging.refines(String)
  end

  Lego = Struct.new(:name)
  using AwesomeSinging[Lego]

  def test_module_refinements
    singer = Lego.new('Emmet')
    assert "Emmett sings Everything is AWESOME!!!", singer.sing
  end
end
