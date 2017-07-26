require "test_helper"

Lego = Struct.new(:name)

module LoudSpeaking
  def speak(words)
    "#{name}: #{words.upcase}!!!"
  end
end

module LoudSpeakingLego
  refine Lego do
    include LoudSpeaking
  end
end

class TypeWrapper::ForwardingTest < Minitest::Test
  LoudLego =
    Struct.new(:speaker).
      include TypeWrapper::Forwarding.
        new(LoudSpeakingLego, :speak, to: :speaker)

  def test_module_refinements
    batman = Lego.new('Batman')
    loud_lego = LoudLego.new(batman)
    assert "Batman: I'M BATMAN!!!", loud_lego.speak("I'm Batman")
  end

  def test_new_forwarding
    assert_raises(ArgumentError) { TypeWrapper::Forwarding.new LoudSpeakingLego }
    assert_raises(ArgumentError) { TypeWrapper::Forwarding.new LoudSpeakingLego, :speak }
    assert_raises(ArgumentError) { TypeWrapper::Forwarding.new LoudSpeakingLego, to: :target }
    assert_raises(ArgumentError) { TypeWrapper::Forwarding.new LoudSpeakingLego, :speak, to: [:target] }
    assert_kind_of Module, TypeWrapper::Forwarding.new(LoudSpeakingLego, :speak, to: :target)
  end

  def test_module_inspect
    mod = TypeWrapper::Forwarding[LoudSpeakingLego, :foo, :bar, to: :target]
    assert_equal "Forwarding[LoudSpeakingLego foo bar to: target]", mod.inspect
  end
end
